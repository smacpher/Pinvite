//
//  searchViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/29/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import Parse
import UIKit

class searchViewController: UIViewController {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    

    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
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
    
    
    
    
}
