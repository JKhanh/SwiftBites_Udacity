//
//  RecipeList.swift
//  SwiftBites
//
//  Created by Khanh on 21/10/24.
//

import SwiftUI
import SwiftData

struct RecipeViewList: View {
  @State private var searchQuery: String = ""
  @Query private var recipeList: [Recipe]
  @State private var sortingOption = SortDescriptor(\Recipe.name)

  init(searchQuery: String) {
    self.searchQuery = searchQuery
    self._recipeList = Query(
      filter: #Predicate<Recipe> { recipe in
        recipe.name.localizedStandardContains(searchQuery) || searchQuery.isEmpty
      }
    )
  }

  var body: some View {
    ScrollView(.vertical) {
      if recipeList.isEmpty {
        noResultsView
      } else {
        LazyVStack(spacing: 12) {
            ForEach(recipeList.sorted(using: sortingOption), content: RecipeCell.init)
        }
      }
    }
    .toolbar {
      if !recipeList.isEmpty {
        sortMenu
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(destination: RecipeForm(mode: .add)) {
            Label("Add", systemImage: "plus")
          }
        }
      }
    }
  }

  @ToolbarContentBuilder
  private var sortMenu: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Menu("Sort", systemImage: "arrow.up.arrow.down") {
        Picker("Sort", selection: $sortingOption) {
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

  private var noResultsView: some View {
    VStack {
      Text("No recipes found for \"\(searchQuery)\"")
        .font(.headline)
        .padding()
    }
  }
}
