//
//  IngredientsDataSource.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 9/26/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import Foundation

class IngredientsDataSource: SmartGroceryListDataSource {
    
    private var ingredients: [String] = []
    
    func addItem(_ item: String) {
        ingredients.append(item)
    }
    
    func items() -> [String] {
        return ingredients
    }
}
