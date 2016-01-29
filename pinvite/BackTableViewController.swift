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
        TableArray = ["Home", "Profile", "Logout"]
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Futura", size: 17)
        
        if cell.textLabel?.text == "Logout" {
            cell.textLabel?.textColor = UIColor(red: 255/255, green: 105/255, blue: 97/255, alpha: 0.75)
        }else{
            cell.textLabel?.textColor = UIColor.whiteColor()
        }
        
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0) //transparent
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let logoutIndex = 2
        if indexPath.row == logoutIndex{
            PFUser.logOut()
        }
    }
}