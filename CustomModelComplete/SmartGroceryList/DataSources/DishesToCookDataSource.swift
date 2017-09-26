//
//  DishesToCookDataSource.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 9/26/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import Foundation

class DishesToCookDataSource: SmartGroceryListDataSource {
    
    private var dishesToCook: [String] = []
    
    func addItem(_ item: String) {
        dishesToCook.append(item)
    }
    
    func items() -> [String] {
        return dishesToCook
    }
}
