//
//  RecognizerViewController.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 7/28/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import UIKit

// MARK: - RecognizerViewController: UIViewController

class RecognizerViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var predictionView: PredictionView!
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    
    let CellReuseIdentifer = "GroceryItemCell"
    let imagePickerController = UIImagePickerController()
    let resnet50Model = Resnet50()
    var groceryItems: [String] = []
    var currentPrediction: String?

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        predictionView.isHidden = true
        tableView.reloadData()
    }

    // MARK: Actions
    
    @IBAction func takePhoto() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera

        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto() {
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func addToList() {
        if let predictionToAdd = currentPrediction {
            groceryItems.append(predictionToAdd)
            tableView.reloadData()
        }
    }

    @IBAction func rejectPrediction() {
        clearPrediction()
    }
    
    // MARK: Private

    private func setupPrediction(prediction: String, image: UIImage) {
        predictionView.predictionResultLabel.text = prediction
        predictionView.isHidden = false
        imageView.image = image
        
        currentPrediction = prediction
    }

    private func clearPrediction() {
        predictionView.isHidden = true
        predictionView.predictionResultLabel.text = nil
        imageView.image = nil

        currentPrediction = nil
    }

    private func recognize(image: UIImage) throws -> String {
        if let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image) {
            let prediction = try self.resnet50Model.prediction(image: pixelBufferImage)
            return prediction.classLabel
        } else {
            return "prediction failed"
        }
    }
}

// MARK: - RecognizerViewController: UITableViewDataSource

extension RecognizerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groceryItemCell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifer) as! GroceryItemTableViewCell
        if indexPath.row < groceryItems.count {
            let item = groceryItems[indexPath.row]
            groceryItemCell.nameLabel.text = item
        }
        
        return groceryItemCell
    }
}

// MARK: - RecognizerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RecognizerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            
            if let topPrediction = try? recognize(image: imageSelected) {
                setupPrediction(prediction: topPrediction, image: imageSelected)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
