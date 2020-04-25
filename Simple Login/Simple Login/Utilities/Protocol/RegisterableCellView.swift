//
//  RegisterableCellView.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 25/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

protocol RegisterableCellView {
    static var identifier: String { get }
    static var nib: NSNib { get }
    
    static func register(with tableView: NSTableView)
    static func make(from tableView: NSTableView) -> Self
}

extension RegisterableCellView {
    static var identifier: String {
        return "\(Self.self)"
    }
    
    static var nib: NSNib {
        if let _ = Bundle.main.path(forResource: "\(Self.self)", ofType: "nib"), let nib = NSNib(nibNamed: "\(Self.self)", bundle: Bundle.main) {
            return nib
        }
        
        fatalError("\(Self.self).xib not found")
    }
    
    static func register(with tableView: NSTableView) {
        tableView.register(nib, forIdentifier: NSUserInterfaceItemIdentifier(identifier))
    }
    
    static func make(from tableView: NSTableView) -> Self {
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(identifier), owner: nil) as? Self {
            return cellView
        }
        
        fatalError("\(Self.self) is not registered with tableView")
    }
}
