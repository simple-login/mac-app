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
    @IBOutlet private weak var rootStackView: NSStackView!
    
    // New alias components
    @IBOutlet private weak var newAliasLabel: NSTextField!
    @IBOutlet private weak var hostnameTextField: NSTextField!
    @IBOutlet private weak var customPrefixStatusLabel: NSTextField!
    @IBOutlet private weak var suffixLabel: NSTextField!
    @IBOutlet private weak var createButton: NSButton!
    
    // Go premium components
    @IBOutlet private weak var premiumDescriptionLabel: NSTextField!
    @IBOutlet private weak var upgradeButton: NSButton!
    
    @IBOutlet private weak var scrollView: NSScrollView!
    @IBOutlet private weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var manageAliasesButton: NSTextField!
    @IBOutlet private weak var signOutButton: NSTextField!
    
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    
    lazy private var newAliasComponents: [NSView] = {
        return [newAliasLabel, hostnameTextField, customPrefixStatusLabel, suffixLabel, createButton]
    }()
    
    lazy private var upgradeComponents: [NSView] = {
        return [premiumDescriptionLabel, upgradeButton]
    }()
    
    var apiKey: String?
    private var user: User?
    private var isValidEmailPrefix: Bool = true {
        didSet {
            createButton.isEnabled = isValidEmailPrefix
            
            if isValidEmailPrefix {
                customPrefixStatusLabel.stringValue = "Sounds like a good name 👍"
                customPrefixStatusLabel.textColor = .secondaryLabelColor
                hostnameTextField.textColor = NSColor(named: NSColor.Name("BodyTextColor"))
                
                if hostnameTextField.stringValue == "" {
                    hostnameTextField.stringValue = user?.suggestion ?? "something"
                }
            } else {
                
                customPrefixStatusLabel.textColor = .systemRed
                hostnameTextField.textColor = .systemRed
                
                if hostnameTextField.stringValue.count > ALIAS_PREFIX_MAX_LENGTH {
                    customPrefixStatusLabel.stringValue = "Your alias is too long 😵"
                } else {
                    customPrefixStatusLabel.stringValue = "Only letter, number, dash (-), underscore (_) are allowed"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = rootStackView.intrinsicContentSize
        
        setLoading(false)
        newAliasComponents.forEach({$0.isHidden = true})
        upgradeComponents.forEach({$0.isHidden = true})
        
        // Set minimum width
        rootStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        
        // Set up tableView
        tableView.backgroundColor = NSColor.clear
        tableView.register(NSNib(nibNamed: NSNib.Name("AliasTableCellView"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AliasTableCellView"))
        tableView.register(NSNib(nibNamed: NSNib.Name("EmptyTableCellView"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EmptyTableCellView"))
        
        // Set up bottom options
        let manageAliasesClickGesture = NSClickGestureRecognizer(target: self, action: #selector(manageAliases))
        manageAliasesButton.addGestureRecognizer(manageAliasesClickGesture)
        
        let signOutClickGesture = NSClickGestureRecognizer(target: self, action: #selector(signOut))
        signOutButton.addGestureRecognizer(signOutClickGesture)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        refresh()
    }
    
    private func refresh() {
        getURL { [unowned self] (url) in
            guard let hostname = url?.host, let apiKey = self.apiKey else { return }
            self.setLoading(true)
            SLApiService.fetchUserData(apiKey: apiKey, hostname: hostname) { [weak self] (user, error) in
                guard let self = self else { return }
                self.setLoading(false)
                
                if let error = error {
                    switch error {
                    case .invalidApiKey:
                        // Invalid API key, prompt user to open host app
                        let alert = NSAlert(messageText: "Invalid API key", informativeText: "Please open the app and enter a valid API key", buttonText: "Open app", alertStyle: .informational)
                        let modalResult = alert.runModal()
                        
                        switch modalResult {
                        case .alertFirstButtonReturn: self.openHostApp()
                        default: return
                        }
                        
                        return
                    default:
                        // Unknown error, display error alert
                        let alert = NSAlert(messageText: "Error occured", informativeText: error.description, buttonText: "Close", alertStyle: .critical)
                        alert.runModal()
                        return
                    }
                } else if let user = user {
                    self.user = user
                    self.refreshUIs()
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
    
    private func refreshUIs() {
        guard let user = user else { return }
        hostnameTextField.stringValue = user.suggestion
        suffixLabel.stringValue = user.suffixes[0]
        tableView.reloadData()
        scrollViewHeightConstraint.constant = min(tableView.intrinsicContentSize.height, 400)
        
        if user.canCreateCustom {
            newAliasComponents.forEach({$0.isHidden = false})
            upgradeComponents.forEach({$0.isHidden = true})
        } else {
            newAliasComponents.forEach({$0.isHidden = true})
            upgradeComponents.forEach({$0.isHidden = false})
        }

        print(rootStackView.fittingSize)
        
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
    
    @IBAction private func upgrade(_ sender: Any) {
        guard let url = URL(string: "\(BASE_URL)/dashboard/pricing") else { return }
        NSWorkspace.shared.open(url)
    }
}

// MARK: - Create new alias
extension ExtensionHomeViewController {
    @IBAction private func createNewAlias(_ sender: Any) {
        guard isValidEmailPrefix, let apiKey = apiKey else { return }
        
        let prefix = hostnameTextField.stringValue
        let suffix = suffixLabel.stringValue
        setLoading(true)
        SLApiService.createNewAlias(apiKey: apiKey, prefix: prefix, suffix: suffix) { [weak self] (error) in
            guard let self = self else { return }
            self.setLoading(false)
            
            if let error = error {
                let alert = NSAlert(messageText: "Error occured", informativeText: error.description, buttonText: "Close", alertStyle: .critical)
                alert.runModal()
            } else {
                self.refresh()
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
        let alert = NSAlert()
        alert.messageText = "Confirmation"
        alert.informativeText = "You will be signed out from Simple Login?"
        alert.addButton(withTitle: "Yes, sign me out")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .informational
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn: SLUserDefaultsService.removeApiKey()
        default: return
        }
    }
}

// MARK: - NSTableViewDataSource
extension ExtensionHomeViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let user = user else { return 0 }
        return max(1, user.existingAliases.count)
    }
}

// MARK: - NSTableViewDelegate
extension ExtensionHomeViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let user = user, user.existingAliases.count > 0 else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("EmptyTableCellView"), owner: nil) as? EmptyTableCellView {
                return cell
            }
            
            return nil
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("AliasTableCellView"), owner: nil) as? AliasTableCellView {
            cell.bind(alias: user.existingAliases[row])
            cell.copyAlias = { alias in
                guard let alias = alias else { return }
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(alias, forType: .string)
            }
            
            return cell
        }
        
        return nil
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
