//
//  SmartGroceryListDataSource.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 9/26/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import Foundation

protocol SmartGroceryListDataSource {
    func addItem(_ item: String) -> ()
    func items() -> [String]
}
