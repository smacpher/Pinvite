//
//  ViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/19/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var address1: UILabel!
    
    @IBOutlet weak var address2: UILabel!
    
    @IBOutlet weak var pinButton: UIButton!
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var geoCoder: CLGeocoder!
    
    var previousAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
        
        //pin button configuration
        pinButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        //user location
        self.locationManager.delegate = self
        
        self.mapView.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        geoCoder = CLGeocoder()
        
        //reveal stuff
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
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
            
            let addrList1: Array<String> = Array(addrList[0..<addrList.count/2])
            let addrList2: Array<String> = Array(addrList[addrList.count/2..<addrList.count])
            
            let address = addrList.joinWithSeparator(", ")
            
            let address1 = addrList1.joinWithSeparator(", ")
            
            let address2 = addrList2.joinWithSeparator((", "))
            
            self.address1.text = address1
            
            self.address2.text = address2
            
            self.previousAddress = address
            
        })
    }
    

    //pin's location
    //updates the address label based on center point of mapview
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        if PFUser.currentUser() != nil{
            updateEventPins()
        }
        geoCode(location)
    }
    
    //add event image tapped function

    @IBAction func addEventTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("addEventPopover", sender: self)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }else {
            self.title = "Welcome, " + (PFUser.currentUser()?.username)!
            
        }
    }
    
    
    
    // MARK: UIPopover Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addEventPopover" {
            
            let vc:addEventViewController = segue.destinationViewController as! addEventViewController
            
            vc.eventLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            
            vc.address1 = self.address1.text
            vc.address2 = self.address2.text
            
            let controller = vc.popoverPresentationController

            
            if controller != nil {
                controller?.delegate = self
            }
        }
        
    }
    
    func updateEventPins(){
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                PFUser.currentUser()!.setObject(geoPoint!, forKey: "location")
                PFUser.currentUser()!.saveInBackground()
                
                let userGeoPoint = PFUser.currentUser()!["location"] as! PFGeoPoint
                
                let query = PFQuery(className: "event")
                
                query.whereKey("location", nearGeoPoint: userGeoPoint)
                
                query.limit = 10
                query.includeKey("parent")
                query.findObjectsInBackgroundWithBlock({(objects, error)-> Void in
                    
                    if error == nil {
                        let eventList = objects!
                        
                        for event in eventList{
                            
                            let location = event["location"]
                            let name = event["name"] as! String
                            var eventUser = event["parent"] as! PFUser
                            let query = PFQuery(className: "_User")
                            query.whereKey("objectId", equalTo: eventUser.objectId!)
                            query.findObjectsInBackgroundWithBlock { (users, error) -> Void in
                                if error == nil {
                                    eventUser = (users![0]) as! PFUser
                                }
                            }
                            
                            let userName = eventUser["username"] as! String
                            
                            let coord = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coord
                            annotation.title = name
                            annotation.subtitle = userName
                            self.mapView.addAnnotation(annotation)
                            
                        }
                        
                    }else{
                        print(error)
                    }
                })
                
            }else{
                
                print(error)
            }
        }

    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    
    // MARK: - Location delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2DMake((location!.coordinate.latitude), (location!.coordinate.longitude))
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler:nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: -mapView delegate methods
    
    //override annotation stuff
    
}