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
    //image outlet
    @IBOutlet weak var imageView: UIImageView!
    //init picker
    let imagePicker = UIImagePickerController()
    //runs once all variables are loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    //camera action
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

