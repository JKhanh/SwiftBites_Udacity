//
//  DataContainer.swift
//  SwiftBites
//
//  Created by Khanh on 21/9/24.
//

import Foundation
import SwiftData
import SwiftUI

actor DataContainer {
    
    private static let models: [any PersistentModel.Type] = [Category.self, Recipe.self, Ingredient.self, RecipeIngredient.self]
    
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema(models)
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
//        inputSampleData(context: container.mainContext)
        return container
    }
    
    private static func isDataEmpty<T: PersistentModel>(model: T.Type, context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<T>()
        do {
            let existedData = try context.fetch(descriptor)
            return existedData.isEmpty
        } catch {
            return true
        }
    }
    
    private static func inputSampleData(context: ModelContext) {
        for model in models {
            if isDataEmpty(model: model, context: context) {
                initSampleData(context: context)
                break
            }
        }
    }
    
    private static func initSampleData(context: ModelContext) {
        let pizzaDough = Ingredient(name: "Pizza Dough")
        let tomatoSauce = Ingredient(name: "Tomato Sauce")
        let mozzarellaCheese = Ingredient(name: "Mozzarella Cheese")
        let freshBasilLeaves = Ingredient(name: "Fresh Basil Leaves")
        let extraVirginOliveOil = Ingredient(name: "Extra Virgin Olive Oil")
        let salt = Ingredient(name: "Salt")
        let chickpeas = Ingredient(name: "Chickpeas")
        let tahini = Ingredient(name: "Tahini")
        let lemonJuice = Ingredient(name: "Lemon Juice")
        let garlic = Ingredient(name: "Garlic")
        let cumin = Ingredient(name: "Cumin")
        let water = Ingredient(name: "Water")
        let paprika = Ingredient(name: "Paprika")
        let parsley = Ingredient(name: "Parsley")
        let spaghetti = Ingredient(name: "Spaghetti")
        let eggs = Ingredient(name: "Eggs")
        let parmesanCheese = Ingredient(name: "Parmesan Cheese")
        let pancetta = Ingredient(name: "Pancetta")
        let blackPepper = Ingredient(name: "Black Pepper")
        let driedChickpeas = Ingredient(name: "Dried Chickpeas")
        let onions = Ingredient(name: "Onions")
        let cilantro = Ingredient(name: "Cilantro")
        let coriander = Ingredient(name: "Coriander")
        let bakingPowder = Ingredient(name: "Baking Powder")
        let chickenThighs = Ingredient(name: "Chicken Thighs")
        let yogurt = Ingredient(name: "Yogurt")
        let cardamom = Ingredient(name: "Cardamom")
        let cinnamon = Ingredient(name: "Cinnamon")
        let turmeric = Ingredient(name: "Turmeric")

        let ingredients = [
          pizzaDough,
          tomatoSauce,
          mozzarellaCheese,
          freshBasilLeaves,
          extraVirginOliveOil,
          salt,
          chickpeas,
          tahini,
          lemonJuice,
          garlic,
          cumin,
          water,
          paprika,
          parsley,
          spaghetti,
          eggs,
          parmesanCheese,
          pancetta,
          blackPepper,
          driedChickpeas,
          onions,
          cilantro,
          coriander,
          bakingPowder,
          chickenThighs,
          yogurt,
          cardamom,
          cinnamon,
          turmeric,
        ]

        let italian = Category(name: "Italian")
        let middleEastern = Category(name: "Middle Eastern")
        let southEastAsian = Category(name: "South East Asian")

        let margherita = Recipe(
          name: "Classic Margherita Pizza",
          summary: "A simple yet delicious pizza with tomato, mozzarella, basil, and olive oil.",
          category: italian,
          serving: 4,
          time: 50,
          instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
          imageData: UIImage(named: "margherita")?.pngData()
        )
        margherita.ingredients = [
            RecipeIngredient(ingredient: pizzaDough, recipe: margherita, quantity: "1 ball"),
            RecipeIngredient(ingredient: tomatoSauce, recipe: margherita, quantity: "1/2 cup"),
            RecipeIngredient(ingredient: mozzarellaCheese, recipe: margherita, quantity: "1 cup, shredded"),
            RecipeIngredient(ingredient: freshBasilLeaves, recipe: margherita, quantity: "A handful"),
            RecipeIngredient(ingredient: extraVirginOliveOil, recipe: margherita, quantity: "2 tablespoons"),
            RecipeIngredient(ingredient: salt, recipe: margherita, quantity: "Pinch"),
          ]

        let spaghettiCarbonara = Recipe(
          name: "Spaghetti Carbonara",
          summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
          category: italian,
          serving: 4,
          time: 30,
          instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
          imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
        )
        spaghettiCarbonara.ingredients = [
            RecipeIngredient(ingredient: spaghetti, recipe: spaghettiCarbonara, quantity: "400g"),
            RecipeIngredient(ingredient: eggs, recipe: spaghettiCarbonara, quantity: "4"),
            RecipeIngredient(ingredient: parmesanCheese, recipe: spaghettiCarbonara, quantity: "1 cup, grated"),
            RecipeIngredient(ingredient: pancetta, recipe: spaghettiCarbonara, quantity: "200g, diced"),
            RecipeIngredient(ingredient: blackPepper, recipe: spaghettiCarbonara, quantity: "To taste"),
          ]

        let hummus = Recipe(
          name: "Classic Hummus",
          summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
          category: middleEastern,
          serving: 6,
          time: 10,
          instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
          imageData: UIImage(named: "hummus")?.pngData()
        )
        hummus.ingredients = [
            RecipeIngredient(ingredient: chickpeas, recipe: hummus, quantity: "1 can (15 oz)"),
            RecipeIngredient(ingredient: tahini, recipe: hummus, quantity: "1/4 cup"),
            RecipeIngredient(ingredient: lemonJuice, recipe: hummus, quantity: "3 tablespoons"),
            RecipeIngredient(ingredient: garlic, recipe: hummus, quantity: "1 clove, minced"),
            RecipeIngredient(ingredient: extraVirginOliveOil, recipe: hummus, quantity: "2 tablespoons"),
            RecipeIngredient(ingredient: cumin, recipe: hummus, quantity: "1/2 teaspoon"),
            RecipeIngredient(ingredient: salt, recipe: hummus, quantity: "To taste"),
            RecipeIngredient(ingredient: water, recipe: hummus, quantity: "2-3 tablespoons"),
            RecipeIngredient(ingredient: paprika, recipe: hummus, quantity: "For garnish"),
            RecipeIngredient(ingredient: parsley, recipe: hummus, quantity: "For garnish"),
          ]

        let falafel = Recipe(
          name: "Classic Falafel",
          summary: "A traditional Middle Eastern dish of spiced, fried chickpea balls, often served in pita bread.",
          category: middleEastern,
          serving: 4,
          time: 60,
          instructions: "Soak chickpeas overnight. Blend with onions, garlic, herbs, and spices. Form into balls, add baking powder, and fry until golden.",
          imageData: UIImage(named: "falafel")?.pngData()
        )
        falafel.ingredients = [
            RecipeIngredient(ingredient: driedChickpeas, recipe: falafel, quantity: "1 cup"),
            RecipeIngredient(ingredient: onions, recipe: falafel, quantity: "1 medium, chopped"),
            RecipeIngredient(ingredient: garlic, recipe: falafel, quantity: "3 cloves, minced"),
            RecipeIngredient(ingredient: cilantro, recipe: falafel, quantity: "1/2 cup, chopped"),
            RecipeIngredient(ingredient: parsley, recipe: falafel, quantity: "1/2 cup, chopped"),
            RecipeIngredient(ingredient: cumin, recipe: falafel, quantity: "1 tsp"),
            RecipeIngredient(ingredient: coriander, recipe: falafel, quantity: "1 tsp"),
            RecipeIngredient(ingredient: salt, recipe: falafel, quantity: "1 tsp"),
            RecipeIngredient(ingredient: bakingPowder, recipe: falafel, quantity: "1/2 tsp"),
          ]

        let shawarma = Recipe(
          name: "Chicken Shawarma",
          summary: "A popular Middle Eastern dish featuring marinated chicken, slow-roasted to perfection.",
          category: middleEastern,
          serving: 4,
          time: 120,
          instructions: "Marinate chicken with yogurt, spices, garlic, lemon juice, and olive oil. Roast until cooked. Serve with pita and sauces.",
          imageData: UIImage(named: "chickenShawarma")?.pngData()
        )
        shawarma.ingredients = [
            RecipeIngredient(ingredient: chickenThighs, recipe: shawarma, quantity: "1 kg, boneless"),
            RecipeIngredient(ingredient: yogurt, recipe: shawarma, quantity: "1 cup"),
            RecipeIngredient(ingredient: garlic, recipe: shawarma, quantity: "3 cloves, minced"),
            RecipeIngredient(ingredient: lemonJuice, recipe: shawarma, quantity: "3 tablespoons"),
            RecipeIngredient(ingredient: cumin, recipe: shawarma, quantity: "1 tsp"),
            RecipeIngredient(ingredient: coriander, recipe: shawarma, quantity: "1 tsp"),
            RecipeIngredient(ingredient: cardamom, recipe: shawarma, quantity: "1/2 tsp"),
            RecipeIngredient(ingredient: cinnamon, recipe: shawarma, quantity: "1/2 tsp"),
            RecipeIngredient(ingredient: turmeric, recipe: shawarma, quantity: "1/2 tsp"),
            RecipeIngredient(ingredient: salt, recipe: shawarma, quantity: "To taste"),
            RecipeIngredient(ingredient: blackPepper, recipe: shawarma, quantity: "To taste"),
            RecipeIngredient(ingredient: extraVirginOliveOil, recipe: shawarma, quantity: "2 tablespoons"),
          ]
        
        italian.recipes = [
          margherita,
          spaghettiCarbonara,
        ]
        middleEastern.recipes = [
          hummus,
          falafel,
          shawarma,
        ]

        let recipes = [
          margherita,
          spaghettiCarbonara,
          hummus,
          falafel,
          shawarma,
        ]
        for ingredient in ingredients {
            context.insert(ingredient)
        }
        
        context.insert(southEastAsian)
        
        for recipe in recipes {
            context.insert(recipe)
        }
    }
}
