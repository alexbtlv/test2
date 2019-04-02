//
//  RecipeTableViewCell.swift
//  test2
//
//  Created by Alexander Batalov on 3/14/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var recipeVM: RecipeViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let recipeVM = recipeVM else { return }
        recipeImageView.kf.setImage(with: recipeVM.thumbImageURL, placeholder: UIImage(named: "food"))
        nameLabel.text = recipeVM.name
        descriptionLabel.text = recipeVM.description
    }
}
