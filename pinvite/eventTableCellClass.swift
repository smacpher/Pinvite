//
//  eventTableCellClass.swift
//  pinvite
//
//  Created by Sean MacPherson on 1/28/16.
//  Copyright © 2016 loofy. All rights reserved.
//


import UIKit
import Parse

class eventTableCellClass: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!

    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
