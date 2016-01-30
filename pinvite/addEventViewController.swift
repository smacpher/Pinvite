//
//  addEventViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/26/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import Parse
import UIKit


class addEventViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var eventLocation: CLLocation! = nil
    
    var address1: String! = nil
    
    var address2: String! = nil
    
    var geoCoder: CLGeocoder!
    
    let user = PFUser.currentUser()
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var addressField1: UILabel!
    
    @IBOutlet weak var addressField2: UILabel!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBAction func AddEventAction(sender: AnyObject) {
        
        let user = PFUser.currentUser()!
        
        let point = PFGeoPoint(latitude: eventLocation.coordinate.latitude, longitude: eventLocation.coordinate.longitude)
        
        let newEvent = PFObject(className: "event")
        
        newEvent["name"] = eventName.text
        newEvent["location"] = point
        newEvent["parent"] = user
        newEvent["locationString"] = self.address1 + ", " +  self.address2
        newEvent.saveInBackground()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.addressField1.text = self.address1
        self.addressField2.text = self.address2
        addEventButton.layer.cornerRadius = 5
    }
    
}


