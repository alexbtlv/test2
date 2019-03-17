//
//  ABRoundedButton.swift
//  test2
//
//  Created by Alexander Batalov on 3/15/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

@IBDesignable class ABRoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            refreshCorners(cornerRadius)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = .white {
        didSet {
            refreshColor(backgroundImageColor)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            refreshBorder(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            refreshBorderColor(borderColor)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    private func sharedInit() {
        refreshCorners(cornerRadius)
        refreshColor(backgroundImageColor)
        refreshBorderColor(borderColor)
        refreshBorder(borderWidth)
    }
    
    private func refreshCorners(_ value: CGFloat) {
        layer.cornerRadius = value
    }
    
    private func refreshColor(_ color: UIColor) {
        let image = createImage(fromColor: color)
        setBackgroundImage(image, for: .normal)
        clipsToBounds = true
    }
    
    private func refreshBorder(_ width: CGFloat) {
        layer.borderWidth = width
    }
    
    private func refreshBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
    
    private func createImage(fromColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
