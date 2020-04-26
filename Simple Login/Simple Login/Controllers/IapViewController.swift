//
//  IapViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 26/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

final class IapViewController: NSViewController {
    
    deinit {
        print("IapViewController is deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBActions
extension IapViewController {
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss(nil)
    }
}
