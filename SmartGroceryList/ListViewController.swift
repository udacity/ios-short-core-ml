//
//  ListViewController.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 7/28/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var groceryItems: [GroceryItem] = []
    let CellReuseIdentifer = "GroceryItemCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialGroceryListData()

        tableView.reloadData()
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groceryItemCell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifer) as! GroceryItemTableViewCell
        if indexPath.row < groceryItems.count {
            let item = groceryItems[indexPath.row]
            groceryItemCell.nameLabel.text = item.name
            groceryItemCell.quantityLabel.text = item.quantity
        }

        return groceryItemCell
    }

    // MARK: private

    private func setupInitialGroceryListData() {
        groceryItems = [GroceryItem(name: "eggs", quantity: "6"),
                        GroceryItem(name: "carrots", quantity: "5"),
                        GroceryItem(name: "red pepper", quantity: "1"),
                        GroceryItem(name: "cheddar cheese", quantity: "5 oz"),
                        GroceryItem(name: "pineapple", quantity: "1")]
    }
}

