//
//  ViewController.swift
//  SeeFood
//
//  Created by Mikhail Amshei on 12/15/19.
//  Copyright © 2019 Grodno Apps LLC. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var outPutLabel: UILabel!
    //image outlet
    @IBOutlet weak var imageView: UIImageView!
    //init picker
    let imagePicker = UIImagePickerController()
    //runs once all variables are loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        imagePicker.delegate = self
        imagePicker.sourceType = .camera//or .photoLibrary
        imagePicker.allowsEditing = false
    }
    func detect(image: CIImage) {
        outPutLabel.text = ""
        //vision ml model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading core ml model failed.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            //process the results of that request
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Error downcasting results")
            }
            let maxGuesses = 4
            var text = "Top \(maxGuesses) guesses about this image:\n"
            var guessNumber = 0
            for result in results {
                guessNumber += 1
                if guessNumber == 1 {
                    self.navigationItem.title = result.identifier
                }
                if guessNumber <= maxGuesses {
                    text += "\(result.identifier) with \(String(format: "%.2f", (result.confidence * 100)))% confidence\n"
                } else {
                    break
                }
            }
            self.outPutLabel.text = text
            //sorting through the top 10 results
            guard let result = results.first else {
                fatalError("Unable to extract the first result")
            }
            if result.identifier.contains("hotdog") {
                self.navigationItem.title = "HotDog!"
            } else {
                self.navigationItem.title = "Not A HotDog!"
            }
            print(result.identifier)
        }
        //specify handler
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        //perform the request
        do {
            try handler.perform([request])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
//MARK: - Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //picker is the controller
        //info is a dictionary with image that user picked.
        guard let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("No image was picked")
        }
        //setting image to the image view
        imageView.image = userPickedImage
        imagePicker.dismiss(animated: true, completion: nil)
        guard let cIImage = CIImage(image: userPickedImage) else {
            fatalError("Unable to convert ui image to ci image")
        }
        DispatchQueue.main.async {
            self.detect(image: cIImage)
        }
    }
    //MARK: - UI Actions
    //camera action
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

