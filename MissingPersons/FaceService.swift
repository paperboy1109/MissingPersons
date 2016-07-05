//
//  FaceService.swift
//  MissingPersons
//
//  Created by Daniel J Janiak on 7/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "YOUR API KEY HERE")
}