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
import DatePickerDialog

class editMemoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    var titles:[String] = []
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var editDateSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    
    var saveBtn:UIBarButtonItem!
    var memoTitle:String!
    
    override func viewWillAppear(_ animated: Bool) {
        readTitle()
//        toDoListTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTitleTextField.delegate = self
        editTableView.delegate = self
        dateTextField.delegate = self
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
        
        //dateTextFieldにプレスフォルダーを設定する
        dateTextField.placeholder = "アラート時刻"
        
    }//viewDidLoad終了

    
    //＜タイトルを読むための関数＞
    func readTitle(){
        
        titles = []
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
    
    
    //テキストフィールドをタップして文字が入力可能になる直前にメソッドが呼び出される。戻り値にtrueを返せば文字が入力可能な状態になり、falseを返せば入力不可としてキーボードは表示されない。
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.editTitleTextField {
            readTitle()
        }
        return true
    }

    
    
    

    
    // BarButtonItemキャンセルの前画面に戻す処理.
    @objc func backButton(sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
    }
    // BarButtonItem保存の前画面に戻す処理.
    @objc func saveButton(sender: UIBarButtonItem){
//        print(self.memos)
        _ = navigationController?.popViewController(animated: true)
        
        saveTitle()
    }
    
    func saveTitle() {
        if editTitleTextField.text != "" {
            //AppDelegateを使う準備をしておく
            let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
            
            //エンティティを操作するためのオブジェクトを作成
            let viewContext = appD.persistentContainer.viewContext
            
            //ToDoエンティティオブジェクトを作成
            //forEntityNameは、モデルファイルで決めたエンティティ名（大文字小文字合わせる）
            let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
            
            //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
            let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
            
            let uuid:String = NSUUID().uuidString
            print(uuid)
            
            //レコードオブジェクトに値のセット
            newRecord.setValue(editTitleTextField.text, forKey: "title")
            newRecord.setValue(uuid, forKey: "id")
            newRecord.setValue(Date(), forKey: "saveDate")
            
            
            //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
            do {
                //レコード（行）の即時保存
                try viewContext.save()
            } catch  {
                print("DBへの保存に失敗しました")
            }
            
        }
    }
    

    //表示する個数の設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルオブジェクトの作成
        let cell:CustumCell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CustumCell
        //各プロパティに値を設定
        cell.toDoTitle.text = titles[indexPath.row]

        //作成したcellオブジェクトを戻り値として返す
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected:\(indexPath.row)")
        // 選択したタイトルが取得できる
        print(titles[indexPath.row])
        
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }

}


//    // coreDataの読み込み memoにappendしてる
//    func readMemoData(){
//        print(#function)
//        //配列の初期化
//        memos = []
//
//        //AppDelegateを使う準備をしておく
//        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
//
//        //エンティティを操作するためのオブジェクトを作成
//        let viewContext = appD.persistentContainer.viewContext
//
//        //データを取得するエンティティの指定
////        <>の中はモデルファイルで指定したエンティティ名
//       let query:NSFetchRequest<Memo> = Memo.fetchRequest()
//
////        //===== 絞り込み =====
//        let r_idPredicate = NSPredicate(format: "titleId = %d",titleId)
//        query.predicate = r_idPredicate
//
//
//        do {
//            //データの一括取得
//            let fetchResults = try viewContext.fetch(query)
//            //取得したデータを、デバックエリアにループで表示
//            print(fetchResults.count)
//
//            for result: AnyObject in fetchResults{
//                let memo :String = result.value(forKey: "content") as! String
//
//                print("content:\(memo)")
//
//                let memoTitle :Int64 = result.value(forKey: "titleId") as! Int64
//
//                print("title:\(memoTitle)")
//
//                memos.append(memo)
//            }
//            memos.append("")
//        } catch  {
//        }
//    }



