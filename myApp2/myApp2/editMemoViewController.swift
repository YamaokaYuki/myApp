//
//  editMemoViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/02/17.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import CoreData
import FontAwesome_swift

class editMemoViewController: UIViewController {

    
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var editDateSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    
    var saveBtn:UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        readTitle()
//        toDoListTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readTitle()
        
        // BarButtonItem保存を作成する.
        saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveButton(sender:)))
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        
        // BarButtonItemキャンセルを作成する.
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action:#selector(self.backButton(sender:)))
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setLeftBarButton(cancelBtn, animated: true)
        
    }//viewDidload終了

    
    //＜タイトルを読むための関数＞
    func readTitle(){
        
//        titles = []
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //データを取得するエンティティの指定
        //<>の中はモデルファイルで指定したエンティティ名
        let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //取得したデータを、デバックエリアにループで表示
            print("titleRead",fetchResults.count)
            for result in fetchResults {
                let title:String = result.title!
//                titles.append(title)
            }
        } catch  {
        }
    }
    
    // BarButtonItemキャンセルの前画面に戻す処理.
    @objc func backButton(sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
    }
    // BarButtonItem保存の前画面に戻す処理.
    @objc func saveButton(sender: UIBarButtonItem){
//        print(self.memos)
        _ = navigationController?.popViewController(animated: true)
    }
    

    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }

}


