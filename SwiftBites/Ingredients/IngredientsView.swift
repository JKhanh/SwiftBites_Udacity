import SwiftData
import SwiftUI

struct IngredientsView: View {
  typealias Selection = (Ingredient) -> Void

  let selection: Selection?

  init(selection: Selection? = nil) {
    self.selection = selection
  }
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) private var dismiss
  @State var ingredients: [Ingredient] = []
  @State private var query = ""
  @State private var countIngredients: Int = 0

  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Ingredients")
        .searchable(text: $query)
        .onAppear {
          fetchIngredients()
        }
        .onChange(of: query) {
          fetchIngredients()
        }
        .toolbar {
            if countIngredients > 0 {
            NavigationLink(value: IngredientForm.Mode.add) {
              Label("Add", systemImage: "plus")
            }
          }
        }
        .navigationDestination(for: IngredientForm.Mode.self) { mode in
          IngredientForm(mode: mode)
        }
    }
  }

  // MARK: - Views

  @ViewBuilder
  private var content: some View {
    if countIngredients == 0 {
      empty
    } else {
      list
    }
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

  private var noResults: some View {
    ContentUnavailableView(
      label: {
        Text("Couldn't find \"\(query)\"")
      }
    )
    .listRowSeparator(.hidden)
  }

  private var list: some View {
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

  // MARK: - Data

  private func delete(ingredient: Ingredient) {
    context.delete(ingredient)
  }

  private func fetchIngredients() {
      let sortDescriptor = SortDescriptor<Ingredient>(\.name)
    let descriptor = FetchDescriptor<Ingredient>(
      predicate: #Predicate {
        query.isEmpty || $0.name.localizedStandardContains(query)
      },
      sortBy: [sortDescriptor]
    )
    let countDescriptor = FetchDescriptor<Ingredient>()
    do {
      ingredients = try context.fetch(descriptor)
      countIngredients = try context.fetchCount(countDescriptor)
    } catch {

    }
  }
}
