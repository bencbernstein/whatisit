//
//  ViewController.swift
//  What Is It
//
//  Created by Benjamin Bernstein on 2/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let watson = Watson()
    
    @IBOutlet weak var resultsLabel: UILabel!
    
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
    
    @IBOutlet weak var tellMeButton: UIButton!
    
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
        self.resultsLabel.alpha = 1
        self.resultsLabel.text = "I'm thinking, hang on!..."
        watson.UploadRequest(image: image_data, completion: { (returnClasses) in
            
            self.resultsLabel.text = self.watson.interpretResults(results: returnClasses)
        })
    }
    
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tellMeButton.alpha = 0.0
        resultsLabel.text = "Choose a picture to get started!"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


