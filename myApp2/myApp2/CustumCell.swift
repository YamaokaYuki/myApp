//
//  CustumCell.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/01/31.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CustumCell: UITableViewCell {
 
    @IBOutlet weak var toDoTitle: UILabel!
    
    @IBOutlet weak var fontAwesomeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         fontAwesomeLabel.font = UIFont.fontAwesome(ofSize: 20)
        fontAwesomeLabel.text = String.fontAwesome(code: "fas fa-check-circle").map { $0.rawValue }
        
    }
}
