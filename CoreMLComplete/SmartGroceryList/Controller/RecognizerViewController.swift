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
    @IBOutlet var photoSourceView: UIView!
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    
    let CellReuseIdentifer = "GroceryItemCell"
    let imagePickerController = UIImagePickerController()
    var groceryItems: [String] = []
    var currentPrediction: String?
    let mobileNet = MobileNet()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        predictionView.isHidden = true
        tableView.reloadData()
    }

    // MARK: Actions
    
    @IBAction func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            showCameraNotAvailableAlert()
        }
    }
    
    @IBAction func selectPhoto() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func addToList() {
        if let predictionToAdd = currentPrediction {
            groceryItems.append(predictionToAdd)
            tableView.reloadData()
            clearPrediction()
        }
    }

    @IBAction func rejectPrediction() {
        clearPrediction()
    }
    
    // MARK: Private

    private func setupPrediction(prediction: String, image: UIImage) {
        predictionView.predictionResultLabel.text = prediction
        predictionView.isHidden = false
        photoSourceView.isHidden = true
        imageView.image = image

        currentPrediction = prediction
    }

    private func clearPrediction() {
        predictionView.isHidden = true
        photoSourceView.isHidden = false
        predictionView.predictionResultLabel.text = nil
        imageView.image = nil
        currentPrediction = nil
    }

    private func recognize(image: UIImage) -> String? {
        if let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image) {
            if let prediction = try? self.mobileNet.prediction(image: pixelBufferImage) {
                return prediction.classLabel
            }
        }
        return nil
    }
    
    private func showRecognitionFailureAlert() {
        let alertController = UIAlertController.init(title: "Recognition Failure", message: "Please try another image.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showCameraNotAvailableAlert() {
        let alertController = UIAlertController.init(title: "Camera Not Available", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
            
            if let topPrediction = recognize(image: imageSelected) {
                setupPrediction(prediction: topPrediction, image: imageSelected)
            } else {
                showRecognitionFailureAlert()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
