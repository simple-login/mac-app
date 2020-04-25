//
//  LoadingTableCellView.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 25/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

final class LoadingTableCellView: NSTableCellView, RegisterableCellView {
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressIndicator.startAnimation(nil)
    }
}
