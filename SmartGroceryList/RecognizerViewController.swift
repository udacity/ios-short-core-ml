//
//  RecognizerViewController.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 7/28/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import UIKit

class RecognizerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var predictionLabel: UILabel!
    @IBOutlet var predictionResultLabel: UILabel!
    @IBOutlet var addToListButton: UIButton!
    @IBOutlet var tableView: UITableView!

    var groceryItems: [GroceryItem] = []
    let CellReuseIdentifer = "GroceryItemCell"

    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self

        setupUI(image: nil)

        setupInitialGroceryListData()

        tableView.reloadData()
    }

    func setupUI(image: UIImage?) {
        imageView.image = image
        predictionLabel.isHidden = image == nil
        predictionResultLabel.isHidden = image == nil
        addToListButton.isHidden = image == nil
    }

    @IBAction func takePhoto() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera

        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func selectPhoto() {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary

        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            setupUI(image: imageSelected)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        groceryItems = [GroceryItem(name: "pineapple", quantity: "1")]
    }
}

