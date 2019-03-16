//
//  StringHelpers.swift
//  test2
//
//  Created by Alexander Batalov on 3/16/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            attributedString.addAttributes([.font : UIFont.systemFont(ofSize: 17)], range: NSRange(location: 0, length: attributedString.string.count))
            return attributedString
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
