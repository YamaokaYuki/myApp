//
//  CustumCell.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/01/31.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Cartography

class CustumCell: UITableViewCell {
 
    @IBOutlet weak var toDoTitle: UILabel!
    
    @IBOutlet weak var fontAwesomeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         fontAwesomeLabel.font = UIFont.fontAwesome(ofSize: 20)
        fontAwesomeLabel.text = String.fontAwesome(code: "fa-chevron-right").map { $0.rawValue }
        fontAwesomeLabel.textColor = UIColor.lightGray
        
        self.toDoTitle.layer.borderColor = UIColor(hex: "#96ffe8").cgColor
        self.toDoTitle.layer.borderWidth = 3
        self.toDoTitle.layer.cornerRadius = 5
        self.toDoTitle.layer.masksToBounds = true
        
    }
    
    
    
    

}
