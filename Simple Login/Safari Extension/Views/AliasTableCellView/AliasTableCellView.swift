//
//  AliasTableCellView.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 03/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

final class AliasTableCellView: NSTableCellView {
    @IBOutlet private weak var aliasLabel: NSTextField!
    @IBOutlet private weak var copyButton: NSButton!
    
    private var alias: String?
    var copyAlias: ((_ alias: String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        
        aliasLabel.backgroundColor = NSColor.clear
        
        copyButton.appearance = NSAppearance(named: .aqua)
    }
    
    @IBAction private func copyButtonClicked(_ sender: Any) {
        copyAlias?(alias)
    }
    
    func bind(alias: String) {
        aliasLabel.stringValue = alias
        self.alias = alias
    }
    
    func setHighLight(_ highLighted: Bool) {
        if highLighted {
            layer?.backgroundColor = NSColor.systemGreen.withAlphaComponent(0.5).cgColor
        } else {
            layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
}
