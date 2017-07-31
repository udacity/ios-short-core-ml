//
//  RecognizerViewController.swift
//  SmartGroceryList
//
//  Created by Meghan Kane on 7/28/17.
//  Copyright © 2017 Meghan Kane. All rights reserved.
//

import UIKit

class RecognizerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var predictionLabel: UILabel!
    @IBOutlet var predictionResultLabel: UILabel!
    @IBOutlet var addToListButton: UIButton!

    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self

        setupUI(image: nil)
    }

    func setupUI(image: UIImage?) {
        imageView.image = image
        predictionLabel.isHidden = image == nil
        predictionResultLabel.isHidden = image == nil
        addToListButton.isHidden = image == nil
    }

    @IBAction func leftButtonTapped(sender: UIButton) {
        selectPhoto()
    }

    @IBAction func rightButtonTapped(sender: UIButton) {
        takePhoto()
    }

    func takePhoto() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera

        present(imagePickerController, animated: true, completion: nil)
    }

    func selectPhoto() {
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

}

