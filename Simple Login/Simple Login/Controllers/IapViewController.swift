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
        /* Opt-out dark mode for this controller because in dark mode labels become white and they are visually dimmed out in the pink background
         */
        view.appearance = NSAppearance(named: .aqua)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        /* Disable resizable for this sheet's window. Must be in viewDidAppear()
        */
        view.window?.styleMask.remove(.resizable)
    }
}

// MARK: - IBActions
extension IapViewController {
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss(nil)
    }
}
