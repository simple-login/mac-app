//
//  AliasTableCellView.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 03/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

final class AliasTableCellView: NSTableCellView, RegisterableCellView {
    @IBOutlet private weak var stackView: NSStackView!
    @IBOutlet private weak var aliasLabel: NSTextField!
    @IBOutlet private weak var latestActivityLabel: NSTextField!
    @IBOutlet private weak var activitiesLabel: NSTextField!
    @IBOutlet private weak var noteLabel: NSTextField!
    @IBOutlet private weak var copyButton: NSButton!
    
    private lazy var labels = [aliasLabel, latestActivityLabel, activitiesLabel, noteLabel]
    
    var didClickCopyButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        labels.forEach({$0?.backgroundColor = .clear})
        
        noteLabel.cell?.wraps = true
        noteLabel.maximumNumberOfLines = 2
        noteLabel.cell?.truncatesLastVisibleLine = true
        
        copyButton.appearance = NSAppearance(named: .aqua)
    }
    
    @IBAction private func copyButtonClicked(_ sender: Any) {
        didClickCopyButton?()
    }
    
    func bind(alias: Alias) {
        aliasLabel.stringValue = alias.email
        
        if let latestActivityString = alias.latestActivityString {
            latestActivityLabel.stringValue = latestActivityString
        } else {
            latestActivityLabel.stringValue = alias.creationString
        }
        
        activitiesLabel.stringValue = alias.activitiesString
        
        noteLabel.isHidden = alias.note == nil
        noteLabel.stringValue = alias.note ?? ""
    }
    
    func setHighLight(_ highLighted: Bool) {
        if highLighted {
            layer?.backgroundColor = NSColor.systemGreen.withAlphaComponent(0.5).cgColor
        } else {
            layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
}
