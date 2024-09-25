//
//  Ingredient.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import Foundation
import SwiftData

@Model
class Ingredient: Identifiable {
    var id: UUID
    var name: String

    init(id: UUID = UUID(), name: String = "") {
      self.id = id
      self.name = name
    }
}
