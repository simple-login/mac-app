//
//  IapViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 26/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa
import StoreKit
import SwiftyStoreKit

final class IapViewController: NSViewController {
    @IBOutlet private weak var rootStackView: NSStackView!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var monthlyButton: NSButton!
    @IBOutlet private weak var yearlyButton: NSButton!
    
    private var productMonthly: SKProduct?
    private var productYearly: SKProduct?
    
    private var selectedIapProduct: IapProduct = .yearly {
        didSet {
            print(selectedIapProduct.productId)
        }
    }
    
    deinit {
        print("IapViewController is deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Opt-out dark mode for this controller because in dark mode labels become white and they are visually dimmed out in the pink background
         */
        view.appearance = NSAppearance(named: .aqua)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        /* Disable resizable for this sheet's window. Must be in viewDidAppear()
        */
        view.window?.styleMask.remove(.resizable)
        
        fetchProducts()
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
    
    private func fetchProducts() {
        setLoading(true)
        
        SwiftyStoreKit.retrieveProductsInfo(Set([IapProduct.monthly.productId, IapProduct.yearly.productId])) { [weak self] (results) in
            guard let self = self else { return }
            self.setLoading(false)
            
            if let error = results.error {
                let alert = NSAlert(error: error)
                alert.runModal()
                self.dismiss(nil)
                return
            }
            
            for product in results.retrievedProducts {
                switch product.productIdentifier {
                case IapProduct.monthly.productId: self.productMonthly = product
                case IapProduct.yearly.productId: self.productYearly = product
                default: break
                }
            }
            
            self.updateButtons()
        }
    }
    
    private func updateButtons() {
        guard let productMonthly = productMonthly, let productYearly = productYearly else {
            let alert = NSAlert(messageText: "Error occured", informativeText: "Error retrieving products", buttonText: "Close", alertStyle: .critical)
            alert.runModal()
            self.dismiss(nil)
            return
        }
        
        monthlyButton.title = "Monthly subscription \(productMonthly.regularPrice ?? "")/month"
        yearlyButton.title = "Yearly subscription \(productYearly.regularPrice ?? "")/year"
    }
    
    private func restart() {
        guard let resourcePath = Bundle.main.resourcePath else { return }
        let url = URL(fileURLWithPath: resourcePath)
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
        exit(0)
    }
}

// MARK: - Payment
extension IapViewController {
    private func buy(_ product: SKProduct) {
        setLoading(true)
        SwiftyStoreKit.purchaseProduct(product.productIdentifier) { [weak self] (result) in
            guard let self = self else { return }
            self.setLoading(false)
            
            switch result {
            case .success(_):
                self.fetchAndSendReceiptToServer()
                
            case .error(let error):
                let errorMessage: String
                switch error.code {
                case .unknown: errorMessage = "Unknown error"
                case .clientInvalid: errorMessage =  "Invalid client"
                case .paymentCancelled: errorMessage = "Payment cancelled"
                case .paymentInvalid: errorMessage = "Invalid payment"
                case .paymentNotAllowed: errorMessage = "Payment not allowed"
                case .storeProductNotAvailable: errorMessage = "Product is not available"
                case .cloudServicePermissionDenied: errorMessage = "Cloud service permission denied"
                case .cloudServiceNetworkConnectionFailed: errorMessage = "Cloud service network connection failed"
                case .cloudServiceRevoked: errorMessage =  "Cloud service revoked"
                default: errorMessage = "Error: \((error as NSError).localizedDescription)"
                }
                
                let alert = NSAlert(messageText: "Error purchasing product", informativeText: errorMessage, buttonText: "Close", alertStyle: .warning)
                alert.runModal()
            }
        }
    }
    
    private func fetchAndSendReceiptToServer() {
        guard let apiKey = SLUserDefaultsService.getApiKey() else {
            return
        }
        
        setLoading(true)
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                SLApiService.processPayment(apiKey: apiKey, receiptData: encryptedReceipt) { [weak self] processPaymentResult in
                    guard let self = self else { return }
                    self.setLoading(false)
                    
                    switch processPaymentResult {
                    case .success(_):
                        self.alertPaymentSuccessful()
  
                    case .failure(let error):
                        let alert = NSAlert(error: error)
                        alert.runModal()
                    }
                }
                
            case .error(let error):
                self.setLoading(false)
                let alert = NSAlert(messageText: "Error occured", informativeText: "Fetch receipt failed: \(error). Please contact us for further assistance.", buttonText: "Close", alertStyle: .critical)
                alert.runModal()
            }
        }
    }
    
    private func alertPaymentSuccessful() {
        let alert = NSAlert(messageText: "Thank you for using our service", informativeText: "The app will be refreshed shortly.", buttonText: "Got it", alertStyle: .informational)
        
        switch alert.runModal() {
        default: restart()
        }
    }
}

// MARK: - IBActions
extension IapViewController {
    @objc @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(nil)
    }
    
    @IBAction private func changeSubscription(_ sender: Any) {
        guard let clickedButton = sender as? NSButton else { return }
        
        if clickedButton == yearlyButton {
            selectedIapProduct = .yearly
        } else {
            selectedIapProduct = .monthly
        }
    }
    
    @IBAction private func upgradeButtonClicked(_ sender: Any) {
        let _product: SKProduct?
        switch selectedIapProduct {
        case .monthly: _product = productMonthly
        case .yearly: _product = productYearly
        }
        
        guard let product = _product else {
            let alert = NSAlert(messageText: "Error occured", informativeText: "Product is null", buttonText: "Close", alertStyle: .warning)
            alert.runModal()
            return
        }
        
        buy(product)
    }
    
    @IBAction private func restoreButtonClicked(_ sender: Any) {
        fetchAndSendReceiptToServer()
    }
    
    @IBAction private func contactUsButtonClicked(_ sender: Any) {
        guard let emailService = NSSharingService.init(named: .composeEmail) else { return }
        
        emailService.recipients = ["hi@simplelogin.io"]
        if emailService.canPerform(withItems: [""]) {
            emailService.perform(withItems: [""])
        }
    }
}
