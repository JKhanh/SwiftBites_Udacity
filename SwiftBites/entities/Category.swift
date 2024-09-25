//
//  Category.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import SwiftData
import Foundation

@Model
class Category: Identifiable {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \Recipe.category)
    var recipes: [Recipe]
    
    init(id: UUID = .init(), name: String, recipes: [Recipe] = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
}
