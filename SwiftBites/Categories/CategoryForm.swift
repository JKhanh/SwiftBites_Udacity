import SwiftData
import SwiftUI

struct CategoryForm: View {
  enum Mode: Hashable {
    case add
    case edit(Category)
  }

  var mode: Mode

  init(mode: Mode) {
    self.mode = mode
    switch mode {
    case .add:
      _name = .init(initialValue: "")
      title = "Add Category"
    case .edit(let category):
      _name = .init(initialValue: category.name)
      title = "Edit \(category.name)"
    }
  }

  private let title: String
  @State private var name: String
  @State private var error: Error?
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) private var dismiss
  @FocusState private var isNameFocused: Bool
  @Query
  private var categories: [Category]

  // MARK: - Body

  var body: some View {
    Form {
      Section {
        TextField("Name", text: $name)
          .focused($isNameFocused)
      }
      if case .edit(let category) = mode {
        Button(
          role: .destructive,
          action: {
            delete(category: category)
          },
          label: {
            Text("Delete Category")
              .frame(maxWidth: .infinity, alignment: .center)
          }
        )
      }
    }
    .onAppear {
      isNameFocused = true
    }
    .onSubmit {
      save()
    }
    .alert(error: $error)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save", action: save)
          .disabled(name.isEmpty)
      }
    }
  }

  // MARK: - Data

  private func delete(category: Category) {
    do {
      for recipe in category.recipes {
        recipe.category = nil
      }
      context.delete(category)
      try context.save()
    } catch {
      self.error = error
    }
    dismiss()
  }

  private func save() {
    do {
      switch mode {
      case .add:
        context.insert(Category(name: name))
      case .edit(let category):
        if let updateCategory = categories.first(where: { $0.id == category.id }) {
          updateCategory.name = name
        }
      }
      try context.save()
      dismiss()
    } catch {
      self.error = error
    }
  }

}
