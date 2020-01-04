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
    @IBOutlet private weak var hostnameTextField: NSTextField!
    @IBOutlet private weak var customPrefixStatusLabel: NSTextField!
    @IBOutlet private weak var suffixLabel: NSTextField!
    @IBOutlet private weak var scrollView: NSScrollView!
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var manageAliasesButton: NSTextField!
    @IBOutlet private weak var signOutButton: NSTextField!
    
    var apiKey: String?
    private var user: User?
    private var isValidEmailPrefix: Bool = true {
        didSet {
            if isValidEmailPrefix {
                customPrefixStatusLabel.stringValue = "Sounds like a good name 👍"
                customPrefixStatusLabel.textColor = .secondaryLabelColor
                hostnameTextField.textColor = .black
                
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
        
        // Set minimum width
        rootStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        
        // Set up tableView
        tableView.backgroundColor = NSColor.clear
        tableView.register(NSNib(nibNamed: NSNib.Name("AliasTableCellView"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AliasTableCellView"))
        
        // Set up bottom options
        let manageAliasesClickGesture = NSClickGestureRecognizer(target: self, action: #selector(manageAliases))
        manageAliasesButton.addGestureRecognizer(manageAliasesClickGesture)
        
        let signOutClickGesture = NSClickGestureRecognizer(target: self, action: #selector(signOut))
        signOutButton.addGestureRecognizer(signOutClickGesture)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        getURL { [unowned self] (url) in
            guard let hostname = url?.host, let apiKey = self.apiKey else { return }
            SLApiService.fetchUserData(apiKey: apiKey, hostname: hostname) { [weak self] (user, error) in
                guard let self = self else { return }
                
                if let error = error {
                    switch error {
                    case .invalidApiKey:
                        // TODO: Open host app for user to enter a valid api key
                        return
                    default:
                        // TODO: Display error
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
        scrollView.heightAnchor.constraint(equalToConstant: tableView.intrinsicContentSize.height).isActive = true
        preferredContentSize = rootStackView.intrinsicContentSize
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
        return user?.existingAliases.count ?? 0
    }
}

// MARK: - NSTableViewDelegate
extension ExtensionHomeViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("AliasTableCellView"), owner: nil) as? AliasTableCellView {
            cell.bind(alias: user!.existingAliases[row])
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
