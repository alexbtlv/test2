//
//  Recepie.swift
//  test2
//
//  Created by Alexander Batalov on 3/13/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation


struct Recipe: Codable {
    let uuid: String?
    let name: String?
    let images: [String]?
    let lastUpdated: Int?
    let description: String?
    let instructions: String?
    let difficulty: Int?
    var thumbImageURL: URL {
        if let first = images?.first, let firstURL = URL(string: first) {
            return firstURL
        }
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        guard let dirPath = paths.first else { preconditionFailure("Can not find path") }
        return URL(fileURLWithPath: dirPath).appendingPathComponent("food.png")
    }
}

struct RecipesWrapper: Codable {
    let recipes: [Recipe]
}
