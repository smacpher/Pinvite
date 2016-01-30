//
//  ProfileViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/23/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var eventsNearMeFeed: UIView!
    
  
    @IBOutlet weak var myFriendsEventsFeed: UIView!
    
    
    @IBOutlet weak var myEventsFeed: UIView!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Open.target = self.revealViewController()
        
        Open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    
        navigationController!.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        myEventsFeed.hidden = true
        myFriendsEventsFeed.hidden = true
        eventsNearMeFeed.hidden = false
        profileView.hidden = false
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)

    }
    
    func respondToSwipeGesture(gestureReconizer: UISwipeGestureRecognizer) {
        if let swipeGesture = gestureReconizer as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                
                if self.segmentedControl.selectedSegmentIndex > 0{
                    self.segmentedControl.selectedSegmentIndex -= 1
                }

            case UISwipeGestureRecognizerDirection.Left:
                
                if self.segmentedControl.selectedSegmentIndex < 2 {
                    self.segmentedControl.selectedSegmentIndex += 1
                }
            default:
                break
            }
        }
    }

    @IBAction func changePages(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            myEventsFeed.hidden = true
            myFriendsEventsFeed.hidden = true
            eventsNearMeFeed.hidden = false
            profileView.hidden = false
        case 1:
            myEventsFeed.hidden = true
            myFriendsEventsFeed.hidden = false
            eventsNearMeFeed.hidden = true
            profileView.hidden = false
        case 2:
            myEventsFeed.hidden = false
            myFriendsEventsFeed.hidden = true
            eventsNearMeFeed.hidden = true
            profileView.hidden = false
        default:
            profileView.hidden = false
        }
    }
}