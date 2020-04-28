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
}

// MARK: - IBActions
extension IapViewController {
    @objc @IBAction func cancelButtonTapped(_ sender: Any) {
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
}
