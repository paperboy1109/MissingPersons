//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Daniel J Janiak on 7/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var personImage: UIImageView!
    
    // MARK: - Properties
    var person: Person!
    
    func configureCell(person: Person) {
        
        self.person = person
        
        // Remark: if you don't unwrap person.personImageURL, the images will NOT show up
        if let url = NSURL(string: "\(baseURL)\(person.personImageURL!)") {
            downloadImage(url)
        }
    }
    
    func downloadImage(url: NSURL) {
        getDataFromURL(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {
                    return
                }
                self.personImage.image = UIImage(data: data)
                
                self.person.personImage = self.personImage.image
                
                /* If cell is deallocated this could cause problems*/
                //self.person.downloadFaceId()
            }
        }
    }
    
    func getDataFromURL(url: NSURL, completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
        
    }
    
    func setSelected() {
        personImage.layer.borderWidth = 2.0
        personImage.layer.borderColor = UIColor.yellowColor().CGColor
        
        self.person.downloadFaceId()
    }
}
