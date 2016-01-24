//
//  ProfileContainerViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/24/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import Parse


class ProfileContainerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBOutlet weak var Username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserImage.layer.cornerRadius = UserImage.frame.size.width/2
        
        UserImage.clipsToBounds = true
        
        UserImage.layer.borderColor = UIColor.grayColor().CGColor
        
        UserImage.layer.borderWidth = 3
        
        Username.text = PFUser.currentUser()?.username
        
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
        
        UserImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        UserImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}
