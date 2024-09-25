import SwiftData
import SwiftUI

struct CategoriesView: View {
  @State private var query = ""
  @Environment(\.modelContext) var context
  @State
  private var categories: [Category] = []
  @State
  private var categoryNumber: Int = 0

  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Categories")
        .searchable(text: $query)
        .onChange(of: query) {
          fetchCategories()
        }
        .onAppear {
          fetchCategories()
        }
        .toolbar {
          if categoryNumber > 0 {
            NavigationLink(value: CategoryForm.Mode.add) {
              Label("Add", systemImage: "plus")
            }
          }
        }
        .navigationDestination(for: CategoryForm.Mode.self) { mode in
          CategoryForm(mode: mode)
        }
        .navigationDestination(for: RecipeForm.Mode.self) { mode in
          RecipeForm(mode: mode)
        }
    }
  }

  // MARK: - Views

  @ViewBuilder
  private var content: some View {
    if categoryNumber == 0 {
      empty
    } else {
      list
    }
  }

  private var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Categories", systemImage: "list.clipboard")
      },
      description: {
        Text("Categories you add will appear here.")
      },
      actions: {
        NavigationLink("Add Category", value: CategoryForm.Mode.add)
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
      if categories.isEmpty {
        noResults
      } else {
        LazyVStack(spacing: 10) {
          ForEach(categories, content: CategorySection.init)
        }
      }
    }
  }

  private func fetchCategories() {
      let sortDescriptor = SortDescriptor<Category>(\.name)
    let descriptor = FetchDescriptor<Category>(
      predicate: #Predicate { query.isEmpty || $0.name.localizedStandardContains(query) },
      sortBy: [sortDescriptor]
    )
    let countDescriptor = FetchDescriptor<Category>()
    do {
      categories = try context.fetch(descriptor)
      categoryNumber = try context.fetchCount(countDescriptor)
    } catch {
      categoryNumber = 0
    }
  }
}
