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

    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let recipe = recipe else { return }
        recipeImageView.kf.setImage(with: recipe.thumbImageURL, placeholder: UIImage(named: "food"))
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.description
    }
}
