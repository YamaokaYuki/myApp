//
//  CustumCell.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/01/31.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import FontAwesome_swift
import SCLAlertView//褒めるポップアップ用
import CoreData //CoreData使う時絶対に必要


class CustumCell: UITableViewCell {
 
    @IBOutlet weak var toDoTitle: UILabel!
    
    @IBOutlet weak var fontAwesomeLabel: UILabel!
    
    @IBOutlet weak var checkBtn: UIButton!

    var toDoId:String!
    var checkNum:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.toDoTitle.layer.borderColor = UIColor(hex: "#dfeaeb").cgColor
        self.toDoTitle.layer.borderWidth = 3
        self.toDoTitle.layer.cornerRadius = 5
        self.toDoTitle.layer.masksToBounds = true
    }
    
    @IBAction func checkChangeColor(_ sender: UIButton) {
        
        if checkBtn.tintColor == UIColor.lightGray{
            checkNum = 1
            checkBtn.tintColor = UIColor.blue
            //褒めるポップアップを表示
            if myDefault.bool(forKey: "commentSwitchFlag") == true{
                let r = Int(arc4random()) % functionAlerts.count
                SCLAlertView().showSuccess("おつかれさま！",subTitle:functionAlerts[r] )
            }
        }else if checkBtn.tintColor == UIColor.blue{
            checkNum = 0
            checkBtn.tintColor = UIColor.lightGray
        }
        
        updateCheck()
    }
    
    //✓状態保存
    func updateCheck() {
        
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        //全部取得する
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        //絞り込み検索（更新したいデータを取得する）
        //ここで取得したいデータをとるためのコードを書く
        let  r_idPredicate = NSPredicate(format: "id = %@", toDoId)
        query.predicate = r_idPredicate
        
        
        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults {
                
                //更新する準備（NSManagedObjectにダウンキャスト型変換)
                //recordがひとつのセット
                let record = result as! NSManagedObject
                
                //更新したいデータのセット
                record.setValue(checkNum, forKey: "check")
                
                //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
                do {
                    
                    //レコード（行）の即時保存
                    try viewContext.save()
                } catch  {
                    print("DBへの保存に失敗しました")
                }
            }
        }catch{
            
        }
    }
    

}
