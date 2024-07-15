//
//  MealDataModel.swift
//  Fetch Programming Challenge
//
//  Created by Austin West on 7/13/24.
//

import Foundation

//Data model that represents the dessert list data
class DessertListModel: ObservableObject {
    @Published var desserts: [DessertsTeaser] = []
    
    //Fetches the list of desserts from the themealdb endpoint and decodes it to the DessertsTeaserList struct
    //Updates the published dessert variable to notify observers.
    func fetch() async throws {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(DessertsTeaserList.self, from: data)
        
        DispatchQueue.main.async {
            self.desserts = response.meals.sorted { $0.strMeal < $1.strMeal }
        }
    }
}

//Data model that represents dessert data
class DessertModel: ObservableObject {

    //Fetches the specified dessert from the themealdb endpoint with the specified idMeal.
    //Returns a Dessert object from the decoded response.
    func fetch(idMeal: String) async throws -> Dessert {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=" + idMeal)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(DessertsList.self, from: data)
        
        var dessert = Dessert()
        if (response.meals.count > 0) {
            dessert = response.meals[0]
        }
        
        return dessert
    }
}

//Represents the list of meals returned by the filter endpoint of themealdb endpoint
struct DessertsTeaserList: Codable {
    let meals: [DessertsTeaser]
}

//Represents the list of meals returned by the lookup endpoint of themealdb
struct DessertsList: Decodable {
    let meals: [Dessert]
}

//Represents the individual dessert teaser returned in the filter endpoint of themealdb
struct DessertsTeaser: Codable, Identifiable {
    var id = UUID()
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
    }
}

//Represents the individual dessert returned by the lookup endpoint of themealdb
struct Dessert: Decodable {
    var idMeal: String
    var strMeal: String
    var strInstructions: String
    var strMealThumb: String
    var ingredients: [String]
    var measurements: [String]
    
    //Custom decoder initalizer
    init(from decoder: Decoder) throws {
        ingredients = []
        measurements = []
        
        //Decode basic keys directly to their fields
        let basicContainer = try decoder.container(keyedBy: BasicCodingKeys.self)
        idMeal = try basicContainer.decode(String.self, forKey: .idMeal)
        strMeal = try basicContainer.decode(String.self, forKey: .strMeal)
        strInstructions = try basicContainer.decode(String.self, forKey: .strInstructions)
        strMealThumb = try basicContainer.decode(String.self, forKey: .strMealThumb)

        //Decode ingredient keys, filter out empty values, add to ingredients field
        let ingredientContainer = try decoder.container(keyedBy: IngredientCodingKeys.self)
        for ingredientKey in IngredientCodingKeys.allCases {
            //If let, to detect null values
            if let ingredient = try ingredientContainer.decodeIfPresent(String.self, forKey: ingredientKey) {
                if(ingredient != "") {
                    ingredients.append(ingredient)
                }
            }
        }
        
        //Decode measurement keys, filter out empty values, add to ingredients field
        let measurementContainer = try decoder.container(keyedBy: MeasurementCodingKeys.self)
        for measurementKey in MeasurementCodingKeys.allCases {
            //If let, to detect null values
            if let measurement = try measurementContainer.decodeIfPresent(String.self, forKey: measurementKey) {
                if(measurement != "") {
                    measurements.append(measurement)
                }
            }
        }
    }
    
    //Default dessert object that represents a fallback state.
    init() {
        idMeal = "-1"
        strMeal = "Not Available"
        strInstructions = "Not Available"
        strMealThumb = "https://via.placeholder.com/150.png?text=?"
        ingredients = ["Not Available"]
        measurements = ["Not Available"]
    }
    
    //Basic coding keys that can be decoded directly from JSON
    enum BasicCodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strInstructions
        case strMealThumb
    }
    
    //Ingredient only coding keys from JSON that need to be filtered
    enum IngredientCodingKeys: String, CodingKey, CaseIterable {
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
    }
    
    //Measurement only keys from JSON that need to be filtered
    enum MeasurementCodingKeys: String, CodingKey, CaseIterable {
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
}
