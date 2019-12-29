//
//  EnterApiKeyViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Cocoa
import Alamofire

final class EnterApiKeyViewController: NSViewController {
    @IBOutlet private weak var rootStackView: NSStackView!
    @IBOutlet private weak var welcomeLabel: NSTextField!
    @IBOutlet private weak var createAccountLabel: NSTextField!
    @IBOutlet private weak var createAndCopyApiKeyLabel: NSTextField!
    @IBOutlet private weak var apiKeyTextField: NSTextField!
    @IBOutlet private weak var setApiKeyButton: NSButton!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setLoading(false)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction private func setApiKey(_ sender: Any) {
        if (NetworkReachabilityManager()?.isReachable ?? false) == false {
            // No internet connection
            let noInternetAlert = NSAlert()
            noInternetAlert.messageText = "No internet"
            noInternetAlert.informativeText = "Please check your internet connection"
            noInternetAlert.addButton(withTitle: "OK")
            noInternetAlert.alertStyle = .warning
            noInternetAlert.runModal()
            return
        }
        
        setLoading(true)
        
        let enteredApiKey = apiKeyTextField.stringValue
        checkApiKey(apiKey: enteredApiKey) { [weak self] (isValid, data) in
            guard let self = self else { return }
            if (isValid) {
                // API key is valid
                if let data = data {
                    do {
                        let user = try self.parseUser(fromData: data)
                        print(user)
                    } catch {
                        self.showAlertErrorParsingUser()
                    }
                } else {
                    self.showAlertNoDataError()
                }
            } else {
                // API key is invalid
                self.showAlertApiKeyIsInvalid()
            }
        }
    }
    
    private func checkApiKey(apiKey: String, completion: @escaping (_ isValid: Bool, _ responseData: Data?) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        
        AF.request("https://app.simplelogin.io/api/alias/options", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { [weak self] response in
            self?.setLoading(false)

            switch response.response?.statusCode {
            case 200: completion(true, response.data)
            default: completion(false, nil)
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        if (isLoading) {
            rootStackView.alphaValue = 0.7
            setApiKeyButton.isEnabled = false
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(self)
        } else {
            rootStackView.alphaValue = 1.0
            setApiKeyButton.isEnabled = true
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(self)
        }
    }
}

// MARK: Process response from server
extension EnterApiKeyViewController {
    private func showAlertApiKeyIsInvalid() {
        let alert = NSAlert()
        alert.messageText = "API Key is invalid ❌"
        alert.informativeText = "Make sure you entered a valid API Key"
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    private func showAlertNoDataError() {
        let alert = NSAlert()
        alert.messageText = "No data error"
        alert.informativeText = "API key is valid but the server returns no data. Please contact us for further information. We are sorry for the inconvenience."
        alert.addButton(withTitle: "Close")
        alert.alertStyle = .critical
        alert.runModal()
    }
    
    private func parseUser(fromData data: Data) throws -> User {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw SLError.failToParseUser
        }
        
        let canCreateCustom = jsonDictionary["can_create_custom"] as? Bool
        let existingAliases = jsonDictionary["existing"] as? [String]
        let customDictionary = jsonDictionary["custom"] as? [String : Any]
        let suffixes = customDictionary?["suffixes"] as? [String]
        let suggestion = customDictionary?["suggestion"] as? String
        
        if let canCreateCustom = canCreateCustom,
            let existingAliases = existingAliases,
            let suffixes = suffixes,
            let suggestion = suggestion {
                return User(canCreateCustom: canCreateCustom, suffixes: suffixes, suggestion: suggestion, existingAliases: existingAliases)
        } else {
            throw SLError.failToParseUser
        }
        
    }
    
    private func showAlertErrorParsingUser() {
        let alert = NSAlert()
        alert.messageText = "Error parsing user data"
        alert.informativeText = "The application can not parse user data returned from server. Please contact us for further information. We are sorry for the inconvenience."
        alert.addButton(withTitle: "Close")
        alert.alertStyle = .critical
        alert.runModal()
    }
}

// MARK: Set up labels
extension EnterApiKeyViewController {
    private func setupLabels() {
        setupWelcomeLabel()
        setupCreateAccountLabel()
        setupCreateAndCopyApiKeyLabel()
    }
    
    private func setupWelcomeLabel() {
        let welcomePlainString = "Welcome to SimpleLogin ↗, the most powerful email alias solution!"
        
        let welcomeAttributedString = NSMutableAttributedString(string: welcomePlainString)
        welcomeAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 20), range: NSMakeRange(0, welcomePlainString.count))
        
        if let simpleLoginStringRange = welcomePlainString.range(of: "SimpleLogin ↗") {
            welcomeAttributedString.addAttributes(
                [.foregroundColor : NSColor(named: NSColor.Name(stringLiteral: "HyperlinkColor")) ?? NSColor.blue,
                 .font : NSFont.systemFont(ofSize: 20, weight: .medium),
                 .underlineStyle : NSUnderlineStyle.single.rawValue,
                 .link : URL(string: "https://simplelogin.io/") as Any,
                 .toolTip : "https://simplelogin.io/"],
                range: NSRange(simpleLoginStringRange, in: welcomePlainString))
            
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        welcomeLabel.allowsEditingTextAttributes = true
        welcomeLabel.attributedStringValue = welcomeAttributedString
    }
    
    private func setupCreateAccountLabel() {
        let createAccountPlainString = "Create your SimpleLogin account here if this is not already done."
        
        let createAccountAttributedString = NSMutableAttributedString(string: createAccountPlainString)
        createAccountAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSMakeRange(0, createAccountPlainString.count))
        
        if let hereStringRange = createAccountPlainString.range(of: "here") {
            createAccountAttributedString.addAttributes(
            [.foregroundColor : NSColor(named: NSColor.Name(stringLiteral: "HyperlinkColor")) ?? NSColor.blue,
             .font : NSFont.systemFont(ofSize: 13, weight: .medium),
             .underlineStyle : NSUnderlineStyle.single.rawValue,
             .link : URL(string: "https://app.simplelogin.io/auth/register") as Any,
             .toolTip : "https://app.simplelogin.io/auth/register"],
            range: NSRange(hereStringRange, in: createAccountPlainString))
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        createAccountLabel.allowsEditingTextAttributes = true
        createAccountLabel.attributedStringValue = createAccountAttributedString
    }
    
    private func setupCreateAndCopyApiKeyLabel() {
        let createAndCopyApiKeyPlainString = "Create and copy your API Key here."
        
        let createAndCopyApiKeyAttributedString = NSMutableAttributedString(string: createAndCopyApiKeyPlainString)
        createAndCopyApiKeyAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSMakeRange(0, createAndCopyApiKeyPlainString.count))
        
        if let hereStringRange = createAndCopyApiKeyPlainString.range(of: "here") {
            createAndCopyApiKeyAttributedString.addAttributes(
            [.foregroundColor : NSColor(named: NSColor.Name(stringLiteral: "HyperlinkColor")) ?? NSColor.blue,
             .font : NSFont.systemFont(ofSize: 13, weight: .medium),
             .underlineStyle : NSUnderlineStyle.single.rawValue,
             .link : URL(string: "https://app.simplelogin.io/dashboard/api_key") as Any,
             .toolTip : "https://app.simplelogin.io/dashboard/api_key"],
            range: NSRange(hereStringRange, in: createAndCopyApiKeyPlainString))
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        createAndCopyApiKeyLabel.allowsEditingTextAttributes = true
        createAndCopyApiKeyLabel.attributedStringValue = createAndCopyApiKeyAttributedString
    }
}
