//
//  RecipeViewModel.swift
//  test2
//
//  Created by Alexander Batalov on 4/1/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

class RecipeViewModel {
    
    private let recipe: Recipe
    
    public var name: String {
        return recipe.name
    }
    
    public var description: String {
        return recipe.description ?? ""
    }
    
    public var thumbImageURL: URL? {
        if let first = recipe.images?.first, let url = URL(string: first) {
            return url
        }
        return nil
    }
    
    public var lastUpdated: Int {
        return recipe.lastUpdated
    }
    
    public var instructions: String {
        return recipe.instructions ?? ""
    }
    
    public var imageURLs: [URL] {
        guard let images = recipe.images else { return [] }
        let possibles = images.map { URL(string: $0) }
        return possibles.compactMap { $0 }
    }
    
    public var instructionsAttributedText: NSAttributedString {
        return recipe.instructions?.htmlToAttributedString ?? NSAttributedString(string: recipe.instructions ?? "")
    }
    
    public var difficultyRating: Double {
        return Double(recipe.difficulty ?? 0)
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}


extension RecipeViewModel: Equatable {
    static func ==(lhs: RecipeViewModel, rhs: RecipeViewModel) -> Bool {
        return lhs.recipe == rhs.recipe
    }
}


