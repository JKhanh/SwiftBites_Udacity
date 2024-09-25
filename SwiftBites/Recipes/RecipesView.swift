import SwiftData
import SwiftUI

struct RecipesView: View {
  @Environment(\.modelContext) var context
  @State private var query = ""
  @State private var sortOrder = SortDescriptor(\Recipe.name)
  @State private var recipes: [Recipe] = []
  @State private var countRecipe: Int = 0

  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Recipes")
        .searchable(text: $query)
        .onAppear {
          fetchRecipe()
        }
        .onChange(of: query) {
          fetchRecipe()
        }
        .toolbar {
          if countRecipe > 0 {
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
  }

  // MARK: - Views

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

  @ViewBuilder
  private var content: some View {
      if countRecipe == 0 {
      empty
    } else {
      list
        .onChange(of: sortOrder) {
          fetchRecipe()
        }
    }
  }

  var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Recipes", systemImage: "list.clipboard")
      },
      description: {
        Text("Recipes you add will appear here.")
      },
      actions: {
        NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
      }
    )
  }

  private var noResults: some View {
    ContentUnavailableView(
      label: {
        Text("Couldn't find \"\(query)\"")
      }
    )
  }

  private var list: some View {
    ScrollView(.vertical) {
      if recipes.isEmpty {
        noResults
      } else {
        LazyVStack(spacing: 10) {
          ForEach(recipes, content: RecipeCell.init)
        }
      }
    }
  }

  private func fetchRecipe() {
    let descriptor = FetchDescriptor<Recipe>(
      predicate: #Predicate {
        query.isEmpty || $0.name.localizedStandardContains(query)
          || $0.summary.localizedStandardContains(query)
      },
      sortBy: [sortOrder]
    )
    let countDescriptor = FetchDescriptor<Recipe>()

    do {
      recipes = try context.fetch(descriptor)
      countRecipe = try context.fetchCount(countDescriptor)
    } catch {

    }
  }
}
