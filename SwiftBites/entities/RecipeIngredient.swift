//
//  RecipeIngredient.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import Foundation
import SwiftData

@Model
class RecipeIngredient: Identifiable, Equatable {
  var id: UUID
  @Relationship(deleteRule: .nullify, inverse: \Ingredient.recipeIngredients)
  var ingredient: Ingredient?

  @Relationship(deleteRule: .nullify, inverse: \Recipe.ingredients)
  var recipe: Recipe?
  var quantity: String

  init(id: UUID = UUID(), ingredient: Ingredient, quantity: String = "") {
    self.id = id
    self.ingredient = ingredient
    self.quantity = quantity
  }

  static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
    lhs.id == rhs.id
  }
}
