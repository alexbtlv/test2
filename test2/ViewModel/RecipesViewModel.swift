//
//  RecipesViewModel.swift
//  test2
//
//  Created by Alexander Batalov on 4/4/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation


class RecipesViewModel {
    
    private var recipeViewModels = [RecipeViewModel]()
    private var filteredRecipeViewModels = [RecipeViewModel]()
    
    public var isEmpty: Bool {
        return recipeViewModels.isEmpty
    }
    
    public var filteredRecipesIsEmpty: Bool {
        return filteredRecipeViewModels.isEmpty
    }
    
    public var numberOfSections: Int {
        return 1
    }
    
    public var numberOfRows: Int {
        return recipeViewModels.count
    }
    
    public var numberOfFilteredRows: Int {
        return filteredRecipeViewModels.count
    }
    
    public func setRecipes(_ recipes: [Recipe]) {
        self.recipeViewModels = recipes.map { RecipeViewModel($0) }
    }
    
    public func recipeViewModelFor(indexPath: IndexPath, isFiltering: Bool) -> RecipeViewModel {
        return isFiltering ? filteredRecipeViewModels[indexPath.row] : recipeViewModels[indexPath.row]
    }
}

extension RecipesViewModel {
    public func filterRecipeBy(text: String, scope: RecipeSearchScope) {
        switch scope {
        case .name:
            filteredRecipeViewModels = recipeViewModels.filter {
                return $0.name.lowercased().contains(text.lowercased())
            }
        case .description:
            filteredRecipeViewModels = recipeViewModels.filter {
                return $0.description.lowercased().contains(text.lowercased())
            }
        case .instructions:
            filteredRecipeViewModels = recipeViewModels.filter {
                return $0.instructions.lowercased().contains(text.lowercased())
            }
        }
    }
    
    public func sortRecipesBy(_ scope: RecipeSortScope, isFiltering: Bool) {
        if isFiltering {
            let sorted = filteredRecipeViewModels.sortedRecipesBy(scope)
            filteredRecipeViewModels = filteredRecipeViewModels == sorted ? sorted.reversed() : sorted
        } else {
            let sorted = recipeViewModels.sortedRecipesBy(scope)
            recipeViewModels = recipeViewModels == sorted ? sorted.reversed() : sorted
        }
    }
}

