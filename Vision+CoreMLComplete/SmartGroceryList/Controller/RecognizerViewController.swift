//
//  RecognizerViewController.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 7/28/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import UIKit
import Vision

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
    let mobileNet = MobileNet()
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

    private func setupPrediction(prediction: String) {
        predictionView.predictionResultLabel.text = prediction
        predictionView.isHidden = false
        photoSourceView.isHidden = true

        currentPrediction = prediction
    }

    private func clearPrediction() {
        predictionView.isHidden = true
        photoSourceView.isHidden = false
        predictionView.predictionResultLabel.text = nil
        imageView.image = nil
        currentPrediction = nil
    }
    
    private func classifyFood(image: UIImage) {
        // 1. Create the vision model, VNCoreMLModel
        guard let visionCoreMLModel = try? VNCoreMLModel(for: mobileNet.model) else {
            fatalError("Unable to convert to Vision Core ML Model")
        }
        
        // 2. Create the request, VNCoreMLRequest
        let foodClassificationRequest = VNCoreMLRequest(model: visionCoreMLModel,
                                                        completionHandler: self.handleFoodClassificationResults)
        
        // 3. Create the request handler, VNImageRequestHandler
        guard let cgImage = image.cgImage else {
            fatalError("Unable to convert \(image) to CGImage.")
        }
        let cgImageOrientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: cgImageOrientation)
        
        // 4. Call perform on the request handler with the request
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([foodClassificationRequest])
            } catch {
                print("Error performing food classification")
            }
        }
    }
    
    // 5. Handle the food classification results
    private func handleFoodClassificationResults(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let classifications = request.results as? [VNClassificationObservation],
                let topClassification = classifications.first else {
                    self.showRecognitionFailureAlert()
                    return
            }
            
            self.setupPrediction(prediction: topClassification.identifier)
        }
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
            imageView.image = imageSelected
            classifyFood(image: imageSelected)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
