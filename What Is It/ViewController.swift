//
//  ViewController.swift
//  What Is It
//
//  Created by Benjamin Bernstein on 2/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let watson = Watson()
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tellMeButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func pickImage(_ sender: UIButton) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        if sender.titleLabel?.text == "Photo Gallery" {
            ImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else {
            ImagePicker.sourceType = .camera
        }
        
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true) { 
            self.tellMeButton.alpha = 1
            self.resultsLabel.alpha = 0
        }
    }
    
    
    @IBAction func tellMeWhatItIs(_ sender: Any) {
        let imageSmaller = image.image!.resized(withPercentage: 0.25)
        guard let image_data = UIImagePNGRepresentation(imageSmaller!) else { return }
        self.tellMeButton.alpha = 0
        progressView.alpha = 1
        self.resultsLabel.alpha = 1
        self.resultsLabel.text = "I'm thinking, hang on!..."
        watson.uploadRequest(image: image_data, completion: { (returnClasses) in
            self.resultsLabel.text = self.watson.interpretResults(results: returnClasses)
            self.progressView.alpha = 0
        }, progressCompletion: { (progress) in
            self.progressView.progress = Float(progress)
        })
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tellMeButton.alpha = 0.0
        resultsLabel.text = "Choose a picture to get started!"
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureRecognizer.delegate = self
        image.addGestureRecognizer(gestureRecognizer)
        image.isUserInteractionEnabled = true
        
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = .camera
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


