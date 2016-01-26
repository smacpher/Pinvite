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

    
    @IBOutlet weak var pinButton: UIButton!
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
        
        //pin button configuration
        pinButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        
        //user location
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        
        //reveal stuff
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
            
            let vc = segue.destinationViewController 
            
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
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
    
    
}

