//
//  RecipeDetailViewController.swift
//  test2
//
//  Created by Alexander Batalov on 3/14/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageGalleryView: RecipeImageGalleryView!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        title = recipe.name
        recipeImageGalleryView.images = recipe.images
    }
}
