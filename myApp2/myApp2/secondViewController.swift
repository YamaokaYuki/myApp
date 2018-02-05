//
//  secondViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/02/03.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import CoreData //CoreData使う時絶対に必要

//titleのグローバル変数を作る
var titles:[String] = [""]

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var newTableView: UITableView!
    @IBOutlet weak var newTextField: UITextField!
    @IBOutlet weak var dateTapSwitch: UISwitch!
    @IBOutlet weak var koteiSwitch: UISwitch!
    
    
    var memos:[String] = [""]
    
    
    
    //そのグローバル変数を作った後にtitleを保存してあげる
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()
        
       
        // newTextFieldにプレスフォルダーを設定
        newTextField.placeholder = "新規登録"
        
        
        //日付の表示・非表示を表す変数を用意
        
        //UserDefaultから値を取り出す
        
        var myDefault = UserDefaults.standard
        myDefault.object(forKey: "imageSwitchFlag")
        
        //日付の表示/非表示を表す変数を用意
        var imageSwitchFlag = true
        
        
        // SwitchをOnに設定しない.
        dateTapSwitch.isOn = false
        //保存されてる値が存在した時
        if myDefault.object(forKey: "imageSwitchFlag") != nil{
            imageSwitchFlag = myDefault.object(forKey: "imageSwitchFlag")as! Bool
            dateTapSwitch.isOn = imageSwitchFlag
        }
        
        
        
        //固定の表示・非表示を表す変数を用意
        
        //UserDefaultから値を取り出す
        
        var myDefaultKotei = UserDefaults.standard
        myDefaultKotei.object(forKey: "koteiSwitchFlag")
        
        //固定の表示/非表示を表す変数を用意
        var koteiSwitchFlag = true
        
        
        // SwitchをOnに設定しない.
        dateTapSwitch.isOn = false
        //保存されてる値が存在した時
        if myDefaultKotei.object(forKey: "koteiSwitchFlag") != nil{
            koteiSwitchFlag = myDefault.object(forKey: "koteiSwitchFlag")as! Bool
            koteiSwitch.isOn = imageSwitchFlag
        }


    }
    
    func read(){
        
        //配列の初期化
        
        memos = []
        
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //データを取得するエンティティの指定
//        <>の中はモデルファイルで指定したエンティティ名
       let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()

        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //取得したデータを、デバックエリアにループで表示
            print(fetchResults.count)

            for result: AnyObject in fetchResults{
                let memo :String = result.value(forKey: "memo") as! String

                print("memo:\(memo)")

                memos.append(memo)
            }
            memos.append("")
        } catch  {

        }
        
    }
    
    
    
    func titleRead(){

        //配列の初期化

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

//            for result: AnyObject in fetchResults{
//                let title :String = result.value(forKey: "title") as! String
//
//                print("title:\(title)")
//
//                titles.append(title)
//            }
            titles.append("")
        } catch  {

        }

    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //行数の決定
        read()
        return memos.count
        
      
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewCustumCell
        cell.tableView = newTableView
        cell.newTextFieldCell.text = memos[indexPath.row]
        
        return cell
    }
    
    func saveTitle() {
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate

        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext

        //ToDoエンティティオブジェクトを作成
        //forEntityNameは、モデルファイルで決めたエンティティ名（大文字小文字合わせる）
        let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)

        //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)

        //レコードオブジェクトに値のセット
        newRecord.setValue(newTextField.text, forKey: "title")

        //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
        do {
            //レコード（行）の即時保存

            try viewContext.save()
        } catch  {
            print("DBへの保存に失敗しました")
        }
        

        //CoreDataからデータを読み込む処理
//        titleRead()




    }
    
    //title完了ボタンを押した時に発動
    @IBAction func titleCompleteBtn(_ sender: UIButton) {
        
        
    }
    
    //koteiSwitchスイッチの状態が変わった時に発動
    @IBAction func koteiSwitch(_ sender: UISwitch) {
        
  
        //UseDefaultを操作するためのオブジェクトを作成
        
        var myDefaultKotei = UserDefaults.standard
        
        //スイッチの状態を保存
        //set(保存したい値、forKey:保存した値を取り出す時に指定する名前)
        
        myDefaultKotei.set(sender.isOn,forKey: "koteiSwitchFlag")
        
        //即保存させる（これがないと、値が保存されていない時があります）
        
        myDefaultKotei.synchronize()
        
        
    }
    
    
    
    //dateTapSwitchスイッチがの状態が変わった時に発動
    @IBAction func dateTapSwitch(_ sender: UISwitch) {
     
        
        //UseDefaultを操作するためのオブジェクトを作成
        
        var myDefault = UserDefaults.standard
        
        //スイッチの状態を保存
        //set(保存したい値、forKey:保存した値を取り出す時に指定する名前)
        
        myDefault.set(sender.isOn,forKey: "imageSwitchFlag")
        
        //即保存させる（これがないと、値が保存されていない時があります）
        
        myDefault.synchronize()
        
    }
    
    
    
    //画面が表示された時、設定値を反映させる
    override func viewWillAppear(_ animated: Bool){
        
        //UserDefaultから値を取り出す
        
        var myDefault = UserDefaults.standard
        myDefault.object(forKey: "imageSwitchFlag")
        
        //指定日時の表示/非表示を表す変数を用意
        var imageSwitchFlag = true
        
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "imageSwitchFlag") != nil{
            imageSwitchFlag = myDefault.object(forKey: "imageSwitchFlag")as! Bool
        }
        print(imageSwitchFlag)
        
        //保存されているSwitchの状態で日時の表示/非表示を切り替える
        
        
    }

    //newTextFieldリターンキーが押された時にキーボードが下がる
    @IBAction func newTextField(_ sender: UITextField) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
