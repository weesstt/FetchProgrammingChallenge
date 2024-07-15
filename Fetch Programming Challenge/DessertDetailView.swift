//
//  DessertDetailView.swift
//  Fetch Programming Challenge
//
//  Created by Austin West on 7/13/24.
//

import SwiftUI

//View to see dessert details when clicked from ContentView list
struct DessertDetailView: View {
    
    //Initalize the dessert state to the default unavailable dessert constructor.
    @State private var dessert: Dessert = Dessert()
    
    private var dessertModel = DessertModel()
    var idMeal: String

    //Initalize view using the idMeal field, view will update dessert state based on ID on appear.
    init(idMeal: String) {
        self.idMeal = idMeal
    }
    
    var body: some View {
        VStack {
            ScrollView() {
                AsyncImage(url: URL(string: dessert.strMealThumb)) { image in image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .padding()
                    
                Text(dessert.strMeal)
                    .font(.title)
                    .padding(.top)
                
                Divider()
                    .padding()
                
                Text("Ingredients")
                    .font(.title3)
                
                ForEach(0 ..< dessert.ingredients.count, id: \.self) { index in
                    Text(dessert.measurements[index] + " • " + dessert.ingredients[index])
                        .padding([.horizontal, .top], 15)
                }
                
                Divider()
                    .padding()
            
                Text("Instructions")
                    .font(.title3)
                
                Text(dessert.strInstructions)
                    .padding([.horizontal, .top], 15)
            }.onAppear() {
                //Async task to set the dessert state to the supplied idMeal using the dessertModel
                Task {
                    dessert = try await dessertModel.fetch(idMeal: idMeal)
                }
            }
        }
    }
}

#Preview {
    DessertDetailView(idMeal: "52768")
}
