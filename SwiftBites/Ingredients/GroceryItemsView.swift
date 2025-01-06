import SwiftUI
import SwiftData

struct GroceryItemsView: View {
    let onSelectItem: ((Ingredient) -> Void)?

  @Environment(\.dismiss) private var dismissAction
  @Environment(\.modelContext) private var managedContext

  @State private var searchQuery: String = ""
    @Query private var groceryItems: [Ingredient]

    init(searchQuery: String, onSelectItem: ((Ingredient) -> Void)? = nil) {
    self.onSelectItem = onSelectItem
    self.searchQuery = searchQuery
    self._groceryItems = Query(
        filter: #Predicate<Ingredient> { ingredient in
            ingredient.name.localizedStandardContains(searchQuery) || searchQuery.isEmpty
        })
  }

  var body: some View {
    if groceryItems.isEmpty {
      emptyStateView
    } else {
      filteredList(for: groceryItems.filter { searchQuery.isEmpty || $0.name.contains(searchQuery) })
    }
  }

  private var noMatchingResultsView: some View {
    VStack {
      Text("No results found for \"\(searchQuery)\"")
        .font(.headline)
      Spacer()
    }
    .padding()
  }

private func filteredList(for items: [Ingredient]) -> some View {
    List {
      if items.isEmpty {
        noMatchingResultsView
      } else {
        ForEach(items) { item in
          listRow(for: item)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) {
                removeItem(item: item)
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
        }
      }
    }
    .listStyle(.insetGrouped)
  }

  @ViewBuilder
private func listRow(for item: Ingredient) -> some View {
    if let onSelectItem {
      Button(action: {
        onSelectItem(item)
        dismissAction()
      }) {
        rowTitle(for: item)
      }
    } else {
        NavigationLink(destination: IngredientForm(mode: .edit(item))) {
        rowTitle(for: item)
      }
    }
  }

private func rowTitle(for item: Ingredient) -> some View {
    Text(item.name)
      .font(.title3)
      .padding()
  }

  private var emptyStateView: some View {
    VStack {
      Image(systemName: "list.bullet")
        .font(.largeTitle)
        .padding()
      Text("No items found")
        .font(.headline)
        .padding(.bottom, 4)
        NavigationLink(destination: IngredientForm(mode: .add)) {
        Text("Add New Item")
          .bold()
          .padding()
          .background(Color.accentColor)
          .foregroundColor(.white)
          .cornerRadius(8)
      }
    }
  }

  // MARK: - Data Handling

private func removeItem(item: Ingredient) {
    for linkedRecipe in item.recipeIngredients {
      managedContext.delete(linkedRecipe)
    }
    managedContext.delete(item)
    try? managedContext.save()
  }
}
