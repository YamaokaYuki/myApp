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
        symbol.text = String.fontAwesome(code: "fa-plus").map { $0.rawValue }

    }
    
    
    func save() {
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //ToDoエンティティオブジェクトを作成
        //forEntityNameは、モデルファイルで決めたエンティティ名（大文字小文字合わせる）
        let Memo = NSEntityDescription.entity(forEntityName: "Memo", in: viewContext)
        
        //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: Memo!, insertInto: viewContext)
        
        //レコードオブジェクトに値のセット
        
        newRecord.setValue(newTextFieldCell.text, forKey: "content")
        newRecord.setValue(titleId, forKey: "titleId")
        
        
        //ここにtitleのグローバル変数を書いてあげてmemoとtitleを紐づけてあげる
        
        
        //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
        do {
            //レコード（行）の即時保存
            
            try viewContext.save()
        } catch  {
            print("DBへの保存に失敗しました")
        }
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
