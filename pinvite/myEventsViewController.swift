//
//  myEventsViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/28/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreLocation
class myEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var myEvents = [PFObject]()
    
    var geoCoder: CLGeocoder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.layer.masksToBounds = true
        
        let nib = UINib(nibName: "eventTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "eventCell")
        
        geoCoder = CLGeocoder()
        
        let query = PFQuery(className: "event")
        query.whereKey("parent", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("parent")
        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if error == nil {
                //success fetching events
                for event in events! {
                    self.myEvents.append(event)
                }
                self.tableView.reloadData()
                
            }else{
                print(error)
            }
        }
        
    }
    
    func geoCode(location: CLLocation!) {
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            
            let loc: CLPlacemark = placeMarks[0]
            let addressDict: [NSString:NSObject] = loc.addressDictionary as! [NSString:NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            
            
            let address1 = addrList.joinWithSeparator(", ")
            
            let address = address1
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(tableView: UITableView,  cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:eventTableCellClass = tableView.dequeueReusableCellWithIdentifier("eventCell") as! eventTableCellClass
        
        if myEvents.count > 0 {
            let event = myEvents[indexPath.row]
            var eventUser = event["parent"] as! PFUser
            let query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: eventUser.objectId!)
            query.findObjectsInBackgroundWithBlock { (users, error) -> Void in
                if error == nil {
                    eventUser = (users![0]) as! PFUser
                }
            }
            
            let userName = eventUser["username"] as! String

            //let eventLocation = event["location"]
            
            //let eventCLLocation = CLLocation(latitude: eventLocation.latitude, longitude: eventLocation.longitude)
            
            let eventLocationString = event["locationString"] as! String
            
        
            cell.userLabel.text = userName
            cell.eventLabel.text = event["name"] as? String
            cell.locationLabel.text = eventLocationString
            if (PFUser.currentUser()!["profilePicture"]) != nil{
                let profileImage:PFFile = eventUser["profilePicture"] as! PFFile
                
                profileImage.getDataInBackgroundWithBlock{ (imageData:NSData?, error:NSError?)->Void in
                    if (error == nil){
                        let profileImage:UIImage = UIImage(data: (imageData)!)!
                        cell.userImage.image = profileImage
                    }
                }
            }
            
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2
            
            cell.userImage.clipsToBounds = true
            
            cell.userImage.layer.borderColor = UIColor.grayColor().CGColor
            
            cell.userImage.layer.borderWidth = 3
        }
        
        return cell
    }

}
