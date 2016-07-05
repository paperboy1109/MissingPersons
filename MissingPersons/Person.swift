//
//  Person.swift
//  MissingPersons
//
//  Created by Daniel J Janiak on 7/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    var faceID: String?
    var personImage: UIImage?
    var personImageURL: String?
    
    init(personImgURL: String) {
        self.personImageURL = personImgURL
    }
    
    func downloadFaceId() {
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.init().client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                
                if err == nil {
                    var faceID: String?
                    for face in faces {
                        faceID = face.faceId
                        print("Face Id: \(faceID)")
                        break
                    }
                    
                    self.faceID = faceID
                }
            })
        }
    }
}
