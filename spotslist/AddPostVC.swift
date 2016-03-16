//
//  AddPostVC.swift
//  spotslist
//
//  Created by Dide van Berkel on 13-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var makePostBtn: UIButton!
    
    @IBOutlet weak var maxCharactersLbl: UILabel!
    @IBOutlet weak var maxTitleCharactersLbl: UILabel!
    @IBOutlet weak var addPicBtn: UIButton!
    @IBOutlet weak var addLibBtn: UIButton!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImage.layer.cornerRadius = 5.0
        postImage.clipsToBounds = true
        
        makePostBtn.layer.cornerRadius = 5.0
        makePostBtn.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        titleField.delegate = self
        descriptionField.delegate = self
        
        maxCharactersLbl.text = "100"
        maxTitleCharactersLbl.text = "30"
    }

    @IBAction func makePostBtnPressed(sender: UIButton) {
            checkRemainingCharactersForPosting()
    }

    @IBAction func cancelBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPicBtnPressed(sender: AnyObject) {
        sender.setTitle("", forState: .Normal)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openLibraryButton(sender: AnyObject) {
        addPicBtn.setTitle("", forState: .Normal)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        postImage.image = image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        addPicBtn.setTitle("+ Take New Pic", forState: .Normal)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        let allowedCharactersDescription = 100
        let charactersInDescriptionView = descriptionField.text?.characters.count
        let remainingCharactersInDescriptionView = allowedCharactersDescription - charactersInDescriptionView!
        maxCharactersLbl.text = String(remainingCharactersInDescriptionView)
        
        if remainingCharactersInDescriptionView < 0 {
            maxCharactersLbl.textColor = UIColor.redColor()
        } else {
            maxCharactersLbl.textColor = UIColor.blackColor()
        }
        
        let allowedCharactersTitle = 30
        let charactersInTitleView = titleField.text?.characters.count
        let remainingCharactersInTitleView = allowedCharactersTitle - charactersInTitleView!
        maxTitleCharactersLbl.text = String(remainingCharactersInTitleView)
        
        if remainingCharactersInTitleView < 0 {
            maxTitleCharactersLbl.textColor = UIColor.redColor()
        } else {
            maxTitleCharactersLbl.textColor = UIColor.blackColor()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let allowedCharactersDescription = 100
        let charactersInDescriptionView = descriptionField.text?.characters.count
        let remainingCharactersInDescriptionView = allowedCharactersDescription - charactersInDescriptionView!
        maxCharactersLbl.text = String(remainingCharactersInDescriptionView)
        
        if remainingCharactersInDescriptionView < 0 {
            maxCharactersLbl.textColor = UIColor.redColor()
        } else {
            maxCharactersLbl.textColor = UIColor.blackColor()
        }
        
        let allowedCharactersTitle = 30
        let charactersInTitleView = titleField.text?.characters.count
        let remainingCharactersInTitleView = allowedCharactersTitle - charactersInTitleView!
        maxTitleCharactersLbl.text = String(remainingCharactersInTitleView)
        
        if remainingCharactersInTitleView < 0 {
            maxTitleCharactersLbl.textColor = UIColor.redColor()
        } else {
            maxTitleCharactersLbl.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func checkRemainingCharactersForPosting() {
        let allowedCharactersDescription = 100
        let charactersInDescriptionView = descriptionField.text?.characters.count
        let remainingCharactersInDescriptionView = (allowedCharactersDescription - charactersInDescriptionView!)
        
        let allowedCharactersTitle = 30
        let charactersInTitleView = titleField.text?.characters.count
        let remainingCharactersInTitleView = (allowedCharactersTitle - charactersInTitleView!)
        
        if remainingCharactersInDescriptionView < 0 {
            let alert = UIAlertController(title: "Too many characters in description", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if remainingCharactersInTitleView < 0 {
            let alert = UIAlertController(title: "Too many characters in title", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            if let title = titleField.text, let desc = descriptionField.text, let img = postImage.image {
                let imgPath = DataService.instance.saveImageAndCreatePath(img)
                let post = Post(imagePath: imgPath, title: title, description: desc)
                DataService.instance.addPost(post)
                let alert = UIAlertController(title: "Spot is added!", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) -> Void in
                    self.closeMessage()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func closeMessage() {
        delay(0.5) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func delay(delay: Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
}
