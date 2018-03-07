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
    
    @IBOutlet weak var checkBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.toDoTitle.layer.borderColor = UIColor(hex: "#96ffe8").cgColor
        self.toDoTitle.layer.borderWidth = 3
        self.toDoTitle.layer.cornerRadius = 5
        self.toDoTitle.layer.masksToBounds = true
        
        checkBtn.tintColor = UIColor.lightGray
        
    }
    
    @IBAction func checkChangeColor(_ sender: UIButton) {
        print("push1")
        if checkBtn.tintColor == UIColor.lightGray{
            checkBtn.tintColor = UIColor.blue
        }else if checkBtn.tintColor == UIColor.blue{
            checkBtn.tintColor = UIColor.lightGray
        }
        print("sample")
//        if sender.tintColor == UIColor.lightGray{
//            sender.tintColor = UIColor.blue
//        }else if sender.tintColor == UIColor.blue{
//            sender.tintColor = UIColor.lightGray
//        }
//
    }
    
    
    

}
