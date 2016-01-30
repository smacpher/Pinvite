//
//  ProfileContainerViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/24/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ProfileContainerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var UserImage: UIImageView!
    
    
    @IBOutlet weak var Username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PFUser.currentUser()!["profilePicture"]) != nil{
            let profileImage:PFFile = PFUser.currentUser()!["profilePicture"] as! PFFile
            
            profileImage.getDataInBackgroundWithBlock{ (imageData:NSData?, error:NSError?)->Void in
                if (error == nil){
                    let profileImage:UIImage = UIImage(data: (imageData)!)!
                    self.UserImage.image = profileImage
                }
            }
        }

        UserImage.layer.cornerRadius = UserImage.frame.size.width/2
        
        UserImage.clipsToBounds = true
        
        UserImage.layer.borderColor = UIColor.grayColor().CGColor
        
        UserImage.layer.borderWidth = 3
        
        self.Username.text = PFUser.currentUser()?.username
        
        
        let gesture = UITapGestureRecognizer(target: self, action: "toggle:")
        view.userInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    func toggle(sender: AnyObject) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }

    
    @IBAction func AddPhoto(sender: AnyObject) {
        
        let photoPicker = UIImagePickerController()
        
        photoPicker.delegate = self
        
        photoPicker.sourceType = .PhotoLibrary
        
        self.presentViewController(photoPicker, animated: true, completion: nil)
        
    }
    
    //Still need to connect image to backend
    
    
    
    // MARK: -imagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let scaledImage = self.scaleImageWith(chosenImage!, and: CGSizeMake(150,150))
        
        let imageData = UIImagePNGRepresentation((scaledImage))
        
        let imageFile:PFFile = PFFile(data: imageData!)!
        
        PFUser.currentUser()?.setObject(imageFile, forKey: "profilePicture")
        
        PFUser.currentUser()?.saveInBackground()
        
        //update image
        self.UserImage.image = scaledImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func scaleImageWith(image: UIImage, and newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0,0,newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}