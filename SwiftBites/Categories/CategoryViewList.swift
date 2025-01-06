//
//  CategoryList.swift
//  SwiftBites
//
//  Created by Khanh on 21/10/24.
//

import SwiftData
import SwiftUI

struct CategoryViewList: View {

  @State private var searchQuery: String = ""
  @Query private var categoryList: [Category]

  init(searchQuery: String) {
    self.searchQuery = searchQuery
    self._categoryList = Query(
      filter: #Predicate<Category> { category in
        category.name.localizedStandardContains(searchQuery) || searchQuery.isEmpty
      }
    )
  }

  var body: some View {
    if categoryList.isEmpty {
      noCategoriesView
    } else {
      ScrollView(.vertical) {
        if categoryList.isEmpty {
          noResultsView
        } else {
          LazyVStack(spacing: 12) {
              ForEach(categoryList, content: CategorySection.init)
          }
        }
      }
    }
  }

  private var noResultsView: some View {
    VStack {
      Text("No results found for \"\(searchQuery)\"")
        .font(.headline)
      Spacer()
    }
    .padding()
  }

  private var noCategoriesView: some View {
    VStack {
      Image(systemName: "tray")
        .font(.largeTitle)
        .padding()
      Text("No Categories Available")
        .font(.headline)
        .padding(.bottom, 4)
      NavigationLink(destination: CategoryForm(mode: .add)) {
        Text("Add New Category")
          .bold()
          .padding()
          .background(Color.accentColor)
          .foregroundColor(.white)
          .cornerRadius(8)
      }
    }
  }
}
