//
//  TableViewHelper.swift
//  test2
//
//  Created by Alexander Batalov on 3/14/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message:String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func removeEmptyMessge() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
