//
//  IngredientList.swift
//  SwiftBites
//
//  Created by Khanh on 21/10/24.
//

import SwiftUI
import SwiftData

struct IngredientList: View {
  let selection: ((Ingredient) -> Void)?

  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context

  @State private var query: String = ""
  @Query private var ingredients: [Ingredient]

  init(query: String, selection: ((Ingredient) -> Void)? = nil) {
    self.selection = selection
    guard !query.isEmpty else { return }
    self.query = query
    self._ingredients = Query(
      filter: #Predicate<Ingredient> { ingredient in
        ingredient.name.contains(query)
      })
  }

  var body: some View {
    if ingredients.isEmpty {
      empty
    } else {
      list(
        for: ingredients.filter {
          if query.isEmpty {
            return true
          } else {
            return $0.name.localizedStandardContains(query)
          }
        })
    }
  }

  private var noResults: some View {
    ContentUnavailableView(
      label: {
        Text("Couldn't find \"\(query)\"")
      }
    )
    .listRowSeparator(.hidden)
  }

  private func list(for ingredients: [Ingredient]) -> some View {
    List {
      if ingredients.isEmpty {
        noResults
      } else {
        ForEach(ingredients) { ingredient in
          row(for: ingredient)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button("Delete", systemImage: "trash", role: .destructive) {
                delete(ingredient: ingredient)
              }
            }
        }
      }
    }
    .listStyle(.plain)
  }

  @ViewBuilder
  private func row(for ingredient: Ingredient) -> some View {
    if let selection {
      Button(
        action: {
          selection(ingredient)
          dismiss()
        },
        label: {
          title(for: ingredient)
        }
      )
    } else {
      NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
        title(for: ingredient)
      }
    }
  }

  private func title(for ingredient: Ingredient) -> some View {
    Text(ingredient.name)
      .font(.title3)
  }

  private var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Ingredients", systemImage: "list.clipboard")
      },
      description: {
        Text("Ingredients you add will appear here.")
      },
      actions: {
        NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
      }
    )
  }

  // MARK: - Data

  private func delete(ingredient: Ingredient) {
    for recipeIngredient in ingredient.recipeIngredients {
      context.delete(recipeIngredient)
    }
    context.delete(ingredient)
    try? context.save()
  }

}
