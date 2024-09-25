//
//  RecipeIngredient.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import Foundation
import SwiftData

@Model
class RecipeIngredient: Identifiable {
  var id: UUID
    @Relationship()
  var ingredient: Ingredient
  var recipe: Recipe?
  var quantity: String

  init(id: UUID = UUID(), ingredient: Ingredient, recipe: Recipe? = nil, quantity: String = "") {
    self.id = id
    self.ingredient = ingredient
    self.recipe = recipe
    self.quantity = quantity
  }
}
