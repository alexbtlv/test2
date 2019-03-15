//
//  RecipeTableHeaderView.swift
//  test2
//
//  Created by Alexander Batalov on 3/15/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class RecipeTableHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameButton: ABRoundedButton!
    @IBOutlet weak var dateButton: ABRoundedButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RecipeTableHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
