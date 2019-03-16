//
//  ArrayHelpers.swift
//  test2
//
//  Created by Alexander Batalov on 3/16/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

extension Sequence where Element == Recipe {
    
    func sortedRecipesBy(_ scope: SortScope) -> [Recipe] {
        switch scope {
        case .name:
            return self.sorted(by: { $0.name < $1.name } )
        case .date:
            return self.sorted(by: { $0.lastUpdated < $1.lastUpdated } )
        }
    }
}
