//
//  DessertView.swift
//  Fetch Programming Challenge
//
//  Created by Austin West on 7/13/24.
//

import SwiftUI

//View to see dessert teaser within list
struct DessertView: View {
    
    let dessertTeaser: DessertsTeaser
    
    var body: some View {
        NavigationLink(destination: DessertDetailView(idMeal: dessertTeaser.idMeal)) {
            HStack {
                AsyncImage(url: URL(string: dessertTeaser.strMealThumb)) { image in image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 90, height: 90)
                .clipped()
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .padding(.horizontal)
                
                Text(dessertTeaser.strMeal)
                  .font(.headline)
                  .lineLimit(1)
                Spacer()
            }
        }
        
    }
}

#Preview {
    DessertView(dessertTeaser: DessertsTeaser(idMeal: "52893", strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}
