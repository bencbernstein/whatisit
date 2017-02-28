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


    @IBAction func pickImage(_ sender: Any) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func classify(_ sender: Any) {
        let imageSmaller = image.image!.resized(withPercentage: 0.25)
        guard let image_data = UIImagePNGRepresentation(imageSmaller!) else { return }
        print("imagedata after classify is \(image_data)")
        watson.UploadRequest(image: image_data, completion: { (data) in
//            print("data is \(data)")
//            guard let imageDict = data["images"] as? [Any] else { return print ("couldn't get imagedict") }
//            print("imageDict is \(imageDict)")
//            guard let classifiers = imageDict[0] as? [String: Any] else { return print ("couldn't get classifiers") }
//            print("clasifiers are \(classifiers)")
//            guard let classes = classifiers
//
//        
            //guard let classifiers = imageDict[0] as? String else { return print ("couldn't get classifiers") }
            //print("classifiers is \(classifiers)")
        })
    }
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


