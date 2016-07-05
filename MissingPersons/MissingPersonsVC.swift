//
//  MissingPersonsVC.swift
//  MissingPersons
//
//  Created by Daniel J Janiak on 7/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localHost:6069/img/"

class MissingPersonsVC: UIViewController {
    
    
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Properties
    let missingPeople1 = [
        "person1.jpg",
        "person2.jpg",
        "person3.jpg",
        "person4.jpg",
        "person5.jpg",
        "person6.jpg"
    ]
    
    let missingPeople = [
        Person(personImgURL: "person1.jpg"),
        Person(personImgURL: "person2.jpg"),
        Person(personImgURL: "person3.jpg"),
        Person(personImgURL: "person4.jpg"),
        Person(personImgURL: "person5.jpg"),
        Person(personImgURL: "person6.png")
    ]
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var selectedImg: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Actions
    
    @IBAction func checkMatch(sender: AnyObject) {
        if selectedPerson == nil || !hasSelectedImage {
            showErrorAlert()
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    
                    if err == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        
                        if faceId != nil {
                            // Verify that the two images match
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceID, faceId2: faceId, completionBlock: { (result: MPOVerifyResult!, err: NSError!) in
                                
                                if err == nil {
                                    print(result.confidence)
                                    print(result.isIdentical)
                                    print(result.debugDescription)
                                    
                                    if result.isIdentical {
                                        self.showMatchAlert()
                                    } else {
                                        self.showMismatchAlert()
                                    }
                                    
                                } else {
                                    print(err.debugDescription)
                                }
                                
                            })
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Helpers
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person & Image", message: "Please select a missing person to check and an image from your album", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showMatchAlert() {
        let alert = UIAlertController(title: "It's a match!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showMismatchAlert() {
        let alert = UIAlertController(title: "Not a match", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension MissingPersonsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        
        //let url = NSURL(string: "\(baseURL)\(person.personImageURL)")//"\(baseURL)\(missingPeople[indexPath.row])"
        
        cell.configureCell(person)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        self.selectedPerson = missingPeople[indexPath.row]
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        
        cell.configureCell(selectedPerson!)
        
        cell.setSelected()
        
        // TODO: Freeze the collection view when a missing person image is selected
        // TODO: Provide a reset feature so that the yellow border goes away and the Face Id is not stuck
        // collectionView.scrollEnabled = false
    }
    
}

extension MissingPersonsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImg
            hasSelectedImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        // TODO: Write conditional code to use .Camera
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
}
