//
//  RecipeDetailViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/14/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageGalleryView: RecipeImageGalleryView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        title = recipe.name
        recipeImageGalleryView.images = recipe.images
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.description
        instructionsLabel.attributedText = recipe.instructions?.htmlToAttributedString
        cosmosView.rating = Double(recipe.difficulty ?? 0)
    }
}
