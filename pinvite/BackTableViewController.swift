//
//  BackTableViewController.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/23/16.
//  Copyright © 2016 loofy. All rights reserved.
//

import Foundation
import Parse

class BackTableViewController: UITableViewController {
    
    
    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = ["Home", "Profile"]
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0) //transparent
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
}