//
//  ExtensionHomeViewController.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 30/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import SafariServices

final class ExtensionHomeViewController: SFSafariExtensionViewController {
    static let shared: ExtensionHomeViewController = {
        let shared = ExtensionHomeViewController()
        shared.preferredContentSize = NSSize(width:320, height:400)
        return shared
    }()
    
    // Outlets
    @IBOutlet private weak var usernameLabel: NSTextField!
    @IBOutlet private weak var premiumOrUpgradeLabel: NSTextField!
    
    @IBOutlet private weak var rootStackView: NSStackView!
    
    // New alias components
    @IBOutlet private weak var newAliasLabel: NSTextField!
    @IBOutlet private weak var suffixPrefixStackView: NSStackView!
    @IBOutlet private weak var hostnameTextField: NSTextField!
    @IBOutlet private weak var customPrefixStatusLabel: NSTextField!
    @IBOutlet private weak var suffixPopupButton: NSPopUpButton!
    @IBOutlet private weak var createButton: NSButton!
    
    // Random alias components
    @IBOutlet private weak var createRandomlyUpperSeparator: NSBox!
    @IBOutlet private weak var createRandomlyButton: NSButton!
    @IBOutlet private weak var createRandomlyDescriptionLabel: NSTextField!
    
    // Go premium components
    @IBOutlet private weak var premiumDescriptionLabel: NSTextField!
    
    @IBOutlet private weak var scrollView: NSScrollView!
    @IBOutlet private weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var manageAliasesButton: NSTextField!
    @IBOutlet private weak var signOutButton: NSTextField!
    
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    
    lazy private var newAliasComponents: [NSView] = {
        return [newAliasLabel, suffixPrefixStackView, customPrefixStatusLabel, createButton, createRandomlyUpperSeparator, createRandomlyButton, createRandomlyDescriptionLabel]
    }()
    
    lazy private var upgradeComponents: [NSView] = {
        return [premiumDescriptionLabel]
    }()
    
    var apiKey: String?
    private var userInfo: UserInfo?
    private var userOptions: UserOptions?
    
    // Aliases
    private var aliases: [Alias] = []
    
    private var fetchedPage: Int = -1
    private var isFetching: Bool = false
    private var moreToLoad: Bool = true
    
    private var isValidEmailPrefix: Bool = true {
        didSet {
            createButton.isEnabled = isValidEmailPrefix
            
            if isValidEmailPrefix {
                customPrefixStatusLabel.stringValue = "Sounds like a good name 👍"
                customPrefixStatusLabel.textColor = .secondaryLabelColor
                if #available(OSXApplicationExtension 10.13, *) {
                    hostnameTextField.textColor = NSColor(named: NSColor.Name("BodyTextColor"))
                } else {
                    hostnameTextField.textColor = .black
                }
                
                if hostnameTextField.stringValue == "" {
                    hostnameTextField.stringValue = userOptions?.prefixSuggestion ?? "something"
                }
            } else {
                
                customPrefixStatusLabel.textColor = .systemRed
                hostnameTextField.textColor = .systemRed
                
                if hostnameTextField.stringValue.count == 0 {
                    customPrefixStatusLabel.stringValue = "This field can not be empty"
                } else if hostnameTextField.stringValue.count > ALIAS_PREFIX_MAX_LENGTH {
                    customPrefixStatusLabel.stringValue = "Your alias is too long 😵"
                } else {
                    customPrefixStatusLabel.stringValue = "Only letter, number, dash (-), underscore (_) are allowed"
                }
            }
        }
    }
    
    private var highLightFirstAlias = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = rootStackView.intrinsicContentSize
        
        usernameLabel.stringValue = ""
        premiumOrUpgradeLabel.stringValue = ""
        suffixPopupButton.removeAllItems()
        
        setLoading(false)
        newAliasComponents.forEach({$0.isHidden = true})
        upgradeComponents.forEach({$0.isHidden = true})
        
        // Set minimum width
        rootStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        
        // Set up tableView
        tableView.backgroundColor = NSColor.clear
        
        EmptyTableCellView.register(with: tableView)
        AliasTableCellView.register(with: tableView)
        LoadingTableCellView.register(with: tableView)
        
        // Set up bottom options
        let manageAliasesClickGesture = NSClickGestureRecognizer(target: self, action: #selector(manageAliases))
        manageAliasesButton.addGestureRecognizer(manageAliasesClickGesture)
        
        let signOutClickGesture = NSClickGestureRecognizer(target: self, action: #selector(signOut))
        signOutButton.addGestureRecognizer(signOutClickGesture)
        
        // Fetch aliases
        fetchAliases()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        refresh()
    }
    
    private func refresh() {
        guard let apiKey = self.apiKey else { return }
        // Fetch user info
        self.setLoading(true)
        
        SLApiService.fetchUserInfo(apiKey: apiKey) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)
            
            switch result {
            case .success(let userInfo):
                self.userInfo = userInfo
                self.refreshUserInfo()
                
            case .failure(let error):
                self.showErrorAlert(error)
            }
        }
        
        // Fetch user options
        getURL { [unowned self] (url) in
            let hostname = url?.host ?? ""
            
            self.setLoading(true)
            
            SLApiService.fetchUserOptions(apiKey: apiKey, hostname: hostname) { [weak self] result in
                guard let self = self else { return }
                self.setLoading(false)
                
                switch result {
                case .success(let userOptions):
                    self.userOptions = userOptions
                    self.refreshUserOptions()
                    
                case .failure(let error):
                    switch error {
                    case .invalidApiKey:
                        // Invalid API key, prompt user to open host app
                        let alert = NSAlert(messageText: "Invalid API key", informativeText: "Please open the app and enter a valid API key", buttonText: "Open app", alertStyle: .informational)
                        alert.icon = NSImage(named: NSImage.Name(stringLiteral: "SimpleLogin"))
                        let modalResult = alert.runModal()
                        
                        switch modalResult {
                        case .alertFirstButtonReturn: self.openHostApp()
                        default: return
                        }
                        
                        return
                    default:
                        // Unknown error, display error alert
                        let alert = NSAlert(error: error)
                        alert.runModal()
                        return
                    }
                }
            }
        }
    }
    
    private func getURL(_ completion: @escaping (_ url: URL?) -> Void) {
        SFSafariApplication.getActiveWindow { (window) in
            window?.getActiveTab(completionHandler: { (tab) in
                tab?.getActivePage(completionHandler: { (page) in
                    page?.getPropertiesWithCompletionHandler({ (properties) in
                        completion(properties?.url)
                    })
                })
            })
        }
    }
    
    private func fetchAliases() {
        guard let apiKey = apiKey, moreToLoad, !isFetching else { return }
        
        isFetching = true
        
        SLApiService.fetchAliases(apiKey: apiKey, page: fetchedPage + 1) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let aliases):
                self.moreToLoad = aliases.count > 0
                self.fetchedPage += 1
                self.aliases.append(contentsOf: aliases)
                self.tableView.reloadData()
                
            case .failure(let error):
                let alert = NSAlert(error: error)
                alert.runModal()
            }
        }
    }
    
    private func refreshUserInfo() {
        guard let userInfo = userInfo else { return }
        usernameLabel.stringValue = userInfo.name
        
        if userInfo.isPremium {
            premiumOrUpgradeLabel.stringValue = "Premium"
            premiumOrUpgradeLabel.textColor = .systemGreen
            premiumOrUpgradeLabel.font = NSFont.systemFont(ofSize: 14)
        } else {
            premiumOrUpgradeLabel.stringValue = "Freemium"
            premiumOrUpgradeLabel.textColor = .systemBlue
            premiumOrUpgradeLabel.font = NSFont.boldSystemFont(ofSize: 14)
        }
    }
    
    private func refreshUserOptions() {
        guard let userOptions = userOptions else { return }
        hostnameTextField.stringValue = userOptions.prefixSuggestion
        
        suffixPopupButton.removeAllItems()
        userOptions.suffixes.forEach({suffixPopupButton.addItem(withTitle: $0)})
        
        tableView.reloadData()
        scrollViewHeightConstraint.constant = min(tableView.intrinsicContentSize.height, 400)

        isValidEmailPrefix = userOptions.prefixSuggestion != ""
        
        if userOptions.canCreate {
            newAliasComponents.forEach({$0.isHidden = false})
            upgradeComponents.forEach({$0.isHidden = true})
        } else {
            newAliasComponents.forEach({$0.isHidden = true})
            upgradeComponents.forEach({$0.isHidden = false})
        }
        
        view.layoutSubtreeIfNeeded()
    }
    
    private func setLoading(_ isLoading: Bool) {
        if isLoading {
            rootStackView.disableSubviews(true)
            rootStackView.alphaValue = 0.7
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(nil)
        } else {
            rootStackView.disableSubviews(false)
            rootStackView.alphaValue = 1
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(nil)
        }
    }
    
//    @objc @IBAction private func upgrade(_ sender: Any) {
//        guard let url = URL(string: "\(BASE_URL)/dashboard/pricing") else { return }
//        NSWorkspace.shared.open(url)
//    }
}

// MARK: - Create new alias
extension ExtensionHomeViewController {
    @IBAction private func createNewAlias(_ sender: Any) {
        guard isValidEmailPrefix, let apiKey = apiKey else { return }
        
        let prefix = hostnameTextField.stringValue
        
        guard let suffix = suffixPopupButton.titleOfSelectedItem else {
            showErrorAlert(SLError.emptySuffix)
            return
        }
        
        setLoading(true)
        
        SLApiService.createAlias(apiKey: apiKey, prefix: prefix, suffix: suffix, note: nil) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)
            
            switch result {
            case .success(_):
                self.highLightFirstAlias = true
                self.refresh()
                
            case .failure(let error):
                let alert = NSAlert(messageText: "Error occured", informativeText: error.description, buttonText: "Close", alertStyle: .critical)
                alert.runModal()
            }
        }
    }
    
    @IBAction private func createRandomlyNewAlias(_ sender: Any) {
        guard let apiKey = apiKey else { return }
        
        setLoading(true)
        
        SLApiService.randomAlias(apiKey: apiKey) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)
            
            switch result {
            case .success(_):
                self.highLightFirstAlias = true
                self.refresh()
                
            case .failure(let error):
                let alert = NSAlert(messageText: "Error occured", informativeText: error.description, buttonText: "Close", alertStyle: .critical)
                alert.runModal()
            }
        }
    }
}

// MARK: - Bottom options
extension ExtensionHomeViewController {
    @objc private func manageAliases() {
        guard let url = URL(string: "\(BASE_URL)/dashboard/") else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc private func signOut() {
        let alert = NSAlert.signOutAlert()
        alert.icon = NSImage(named: NSImage.Name(stringLiteral: "SimpleLogin"))
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn:
            SLUserDefaultsService.removeApiKey()
            // Post a notification to host app
            DistributedNotificationCenter.default().post(name: SLNotificationName.signOut, object: nil)
            
        default: return
        }
    }
}

// MARK: - NSTableViewDataSource
extension ExtensionHomeViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if aliases.isEmpty {
            return 1
        }
        
        if moreToLoad {
            return aliases.count + 1
        }
        
        return aliases.count
    }
}

// MARK: - NSTableViewDelegate
extension ExtensionHomeViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard !aliases.isEmpty else {
            return EmptyTableCellView.make(from: tableView)
        }
        
        if moreToLoad && row == aliases.count {
            let loadingCell = LoadingTableCellView.make(from: tableView)
            fetchAliases()
            return loadingCell
        }
        
        let aliasCell = AliasTableCellView.make(from: tableView)
        let alias = aliases[row]
        
        aliasCell.bind(alias: alias)
        aliasCell.didClickCopyButton = { [unowned self] in
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(alias.email, forType: .string)
            
            self.showHUD(attributedMessageString: alias.copyAlertAttributedString)
        }
        
        if highLightFirstAlias && row == 0 {
            aliasCell.setHighLight(true)
            highLightFirstAlias = false
        } else {
            aliasCell.setHighLight(false)
        }
        
        return aliasCell
    }
    
    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        // Disable selection mode
        return false
    }
}

// MARK: - NSTextFieldDelegate
extension ExtensionHomeViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        isValidEmailPrefix = hostnameTextField.stringValue.isValidEmailPrefix()
    }
}
