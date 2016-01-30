import Foundation
import UIKit
import Parse
import CoreLocation

class globalEventsNearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [PFObject]()
    
    var geoCoder: CLGeocoder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.grayColor().CGColor
        tableView.layer.borderWidth = 2
        
        let nib = UINib(nibName: "eventTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "eventCell")
        
        geoCoder = CLGeocoder()
        
        let userGeopoint = PFUser.currentUser()!["location"] as! PFGeoPoint
        let query = PFQuery(className: "event")
        query.whereKey("location", nearGeoPoint: userGeopoint)
        query.orderByDescending("createdAt")
        query.includeKey("parent")
        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if error == nil {
                //success fetching events
                for event in events! {
                    self.events.append(event)
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
        return events.count
    }
    
    func tableView(tableView: UITableView,  cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:eventTableCellClass = tableView.dequeueReusableCellWithIdentifier("eventCell") as! eventTableCellClass
        
        if events.count > 0 {
            let event = events[indexPath.row]
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
