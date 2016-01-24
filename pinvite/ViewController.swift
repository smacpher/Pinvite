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

class ViewController: UIViewController {

    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //reveal stuff
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
    
    @IBAction func LogoutAction(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("gotoLogin", sender: self)

    }
    
}

