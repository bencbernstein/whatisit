//
//  Watson.swift
//  What Is It
//
//  Created by Benjamin Bernstein on 2/28/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import Foundation
import Alamofire

class Watson {
    
    var setClasses: [Any]?
    
    let URL = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=402f52698dc10811e6e2a0323c259c0a89b12f3a&version=2016-05-20"
    
    func uploadRequest(image: Data, completion: @escaping ([Any]) -> Void, progressCompletion: @escaping (Double) -> ())  {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "images_file", mimeType: "image/png")
 
        },
            to: URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
                        progressCompletion(progress.fractionCompleted)
                        print("progress is \(progress.fractionCompleted)")
                    }
                        upload.downloadProgress { progress in // main queue by default
                            print("Download Progress: \(progress.fractionCompleted)")
                    }
                
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let JSON = response.result.value {
                            let json = JSON as! [String : Any]
                            self.setClasses = self.parseJSON(JSON: json)
                            completion(self.setClasses!)
                        }
                    }
                    
                case .failure(let encodingError):
                    print("\n failed upload..")
                    print(encodingError)
                }
        })
        
        
    }
    
    
    
    func parseJSON(JSON: [String: Any] ) -> [Any]? {
        //print("data is \(data)")
        guard let imageDict = JSON["images"] as? [Any] else { print ("couldn't get imagedict"); return nil }
        //print("imageDict is \(imageDict)")
        guard let classifiers = imageDict[0] as? [String: Any] else { print ("couldn't get classifiers"); return nil }
        //print("clasifiers are \(classifiers)")
        guard let classeArray = classifiers["classifiers"] as? [Any] else { print ("couldn't get classes"); return nil }
        //print("classeeArray is \(classeArray)")
        guard let classess = classeArray[0] as? [String: Any] else { print ("couldn't get arrayClass"); return nil }
        return (classess["classes"] as? [Any])!

    }
    
    
    
    func interpretResults(results: [Any]) -> String {
        var topToReturn = "I'm quite sure that's a "
        var otherToReturn = "Generally: "
        var middleToReturn = "Also thinking: "

        for each in results {
            let result = each as! [String: Any]
            let score = result["score"] as! Double
            let type_hierarchy = result["type_hierarchy"] as! String?
            let classifier = result["class"] as! String
            
            print("result is \(result)")
      
            if type_hierarchy != nil && score > 0.5  {
                if topToReturn.contains("! ") == false {
                  topToReturn += "\(classifier)" + "! "
                }
                else {
                middleToReturn += "\(classifier)" + ", "
                }
            } else if score > 0.5 && classifier.contains("color") == false && middleToReturn.contains(classifier) == false
                && topToReturn.contains(classifier) == false && otherToReturn.contains(classifier) == false{
                otherToReturn += "\(classifier)" + ", "
            } else if classifier.contains("color") {
                //TODO: make phone background color that color
            }
        }
        middleToReturn.characters.removeLast()
        middleToReturn.characters.removeLast()
        otherToReturn.characters.removeLast()
        otherToReturn.characters.removeLast()
        
        if topToReturn ==  "I'm quite sure that's a " {
            return otherToReturn
        }
        
        if middleToReturn == "Also thinking" {
            return topToReturn +  "\n" + otherToReturn
        }
        
        return topToReturn + "\n" + middleToReturn + "\n" + otherToReturn
    }
    
    
    
}

