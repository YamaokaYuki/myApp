//
//  NewCustumCell.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/02/03.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import CoreData
import FontAwesome_swift



class NewCustumCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var newTextFieldCell: UITextField!
    @IBOutlet weak var symbol: UILabel!
    
    var tableView:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        symbol.font = UIFont.fontAwesome(ofSize: 20)
        symbol.text = String.fontAwesome(code: "fa-angellist").map { $0.rawValue }
        symbol.textColor = UIColor.lightGray

    }
    
    
    
    func isSet() -> Bool {
        if newTextFieldCell.text != "" {
            return true
        }else{
            return false
        }
    }
    
    

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
