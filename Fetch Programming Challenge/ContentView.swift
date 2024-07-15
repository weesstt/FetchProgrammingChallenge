//
//  ContentView.swift
//  Fetch Programming Challenge
//
//  Created by Austin West on 7/13/24.
//

import SwiftUI

//Main content view that contains dessert list.
struct ContentView: View {
    
    //Data model for dessert list
    @StateObject private var dessertsListModel = DessertListModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dessertsListModel.desserts) { dessert in
                    DessertView(dessertTeaser: dessert)
                }
            }
            .navigationTitle("Desserts")
        }.onAppear() {
            //Async task to fetch and update dessert list data model
            Task {
                do {
                    try await dessertsListModel.fetch()
                } catch {
                    print("An unexpected error: \(error)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
