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
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var predictionView: PredictionView!
    @IBOutlet var tableView: UITableView!

    let CellReuseIdentifer = "GroceryItemCell"

    let imagePickerController = UIImagePickerController()
    let resnet50Model = Resnet50()
    var groceryItems: [GroceryItem] = []
    var currentPrediction: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self

        predictionView.isHidden = true
        setupInitialGroceryListData()

        tableView.reloadData()
    }

    func setupPrediction(prediction: String, image: UIImage) {
        predictionView.predictionResultLabel.text = prediction
        predictionView.isHidden = false
        imageView.image = image

        currentPrediction = prediction
    }

    func clearPrediction() {
        predictionView.isHidden = true
        predictionView.predictionResultLabel.text = nil
        imageView.image = nil

        currentPrediction = nil
    }

    @IBAction func takePhoto() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera

        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func addToList() {
        if let predictionToAdd = currentPrediction {
            let newItem = GroceryItem(name: predictionToAdd, quantity: "1")
            groceryItems.append(newItem)
            tableView.reloadData()
        }
    }
    
    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit

            if let topPrediction = try? recognize(image: imageSelected) {
                setupPrediction(prediction: topPrediction, image: imageSelected)
            }
        }

        dismiss(animated: true, completion: nil)
    }

    // TODO: fix error handling
    func recognize(image: UIImage) throws -> String {
        if let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image) {
            let prediction = try self.resnet50Model.prediction(image: pixelBufferImage)
            return prediction.classLabel
        } else {
            return "prediction failed"
        }
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

