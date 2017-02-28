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
    
    
    let URL = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=402f52698dc10811e6e2a0323c259c0a89b12f3a&version=2016-05-20"

    
//    func fetchKeywords(completion: @escaping ([FIRDataSnapshot]?) -> ()) {
//        guard let safeUserID = userID else {
//            assert(false)
//            completion(nil)
//            return
//        }
//        
    
        
    func UploadRequest(image: Data, completion: @escaping ([String: Any]) -> Void)  {
        print("upload request is happening")
        print("imageData is \(image)")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "images_file", mimeType: "image/png")
               print("the multipart went up...")
        },
            to: URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    print("\n")
                    print("successful upload...")
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            completion(JSON as! [String : Any])
                        }
                    }
                case .failure(let encodingError):
                    print("\n failed upload..")
                    print(encodingError)
                }
        }
        )
    
    
    }

}

