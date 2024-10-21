//
//  Ingredient.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import Foundation
import SwiftData

@Model
class Ingredient: Identifiable, Equatable {
  var id: UUID
  @Attribute(.unique)
  var name: String
    
  @Relationship(deleteRule: .cascade)
  var recipeIngredients = [RecipeIngredient]()

  init(id: UUID = UUID(), name: String = "") {
    self.id = id
    self.name = name
  }

  static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
    lhs.id == rhs.id
  }
}
