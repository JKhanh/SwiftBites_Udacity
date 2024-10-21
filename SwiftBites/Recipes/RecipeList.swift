//
//  RecipeList.swift
//  SwiftBites
//
//  Created by Khanh on 21/10/24.
//

import SwiftUI
import SwiftData

struct RecipeList: View {
  @State private var query: String = ""
  @Query private var recipes: [Recipe]
  @State private var sortOrder = SortDescriptor(\Recipe.name)

  init(query: String) {
    guard !query.isEmpty else { return }
    self.query = query
    self._recipes = Query(
      filter: #Predicate<Recipe> { category in
        category.name.contains(query)
      })
  }

  var body: some View {
    ScrollView(.vertical) {
      if recipes.isEmpty {
        noResults
      } else {
        LazyVStack(spacing: 10) {
          ForEach(recipes.sorted(using: sortOrder), content: RecipeCell.init)
        }
      }
    }
    .toolbar {
      if !recipes.isEmpty {
        sortOptions
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(value: RecipeForm.Mode.add) {
            Label("Add", systemImage: "plus")
          }
        }
      }
    }
    .navigationDestination(for: RecipeForm.Mode.self) { mode in
      RecipeForm(mode: mode)
    }
  }

  @ToolbarContentBuilder
  var sortOptions: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Menu("Sort", systemImage: "arrow.up.arrow.down") {
        Picker("Sort", selection: $sortOrder) {
          Text("Name")
            .tag(SortDescriptor(\Recipe.name))

          Text("Serving (low to high)")
            .tag(SortDescriptor(\Recipe.serving, order: .forward))

          Text("Serving (high to low)")
            .tag(SortDescriptor(\Recipe.serving, order: .reverse))

          Text("Time (short to long)")
            .tag(SortDescriptor(\Recipe.time, order: .forward))

          Text("Time (long to short)")
            .tag(SortDescriptor(\Recipe.time, order: .reverse))
        }
      }
      .pickerStyle(.inline)
    }
  }

  private var noResults: some View {
    ContentUnavailableView(
      label: {
        Text("Couldn't find \"\(query)\"")
      }
    )
  }
}
