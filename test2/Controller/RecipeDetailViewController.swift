//
//  RecipeDetailViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/14/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import Cosmos

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageGalleryView: RecipeImageGalleryView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var recipeVM: RecipeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        recipeImageGalleryView.imageURLs = recipeVM.imageURLs
        nameLabel.text = recipeVM.name
        descriptionLabel.text = recipeVM.description
        instructionsLabel.attributedText = recipeVM.instructionsAttributedText
        cosmosView.rating = recipeVM.difficultyRating
    }
}
