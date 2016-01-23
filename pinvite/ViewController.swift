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

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }else {
            self.usernameLabel.text = "Welcome, " + (PFUser.currentUser()?.username)!
        }
        
    }

    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }
    
    
}

