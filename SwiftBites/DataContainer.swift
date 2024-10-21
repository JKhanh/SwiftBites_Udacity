//
//  DataContainer.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import Foundation
import SwiftData
import SwiftUI

actor DataContainer {
    
    private static let models: [any PersistentModel.Type] = [Category.self, Recipe.self, Ingredient.self, RecipeIngredient.self]
    
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema(models)
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        return container
    }
}
