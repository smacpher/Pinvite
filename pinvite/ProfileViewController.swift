//
//  ProfileViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/23/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation

class Profile: UIViewController {
    
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}