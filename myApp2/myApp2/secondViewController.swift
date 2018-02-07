//
//  secondViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/02/03.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import CoreData //CoreData使う時絶対に必要

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var newTableView: UITableView!
    @IBOutlet weak var newTextField: UITextField!
    @IBOutlet weak var dateTapSwitch: UISwitch!
    @IBOutlet weak var koteiSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    
    let myDefault = UserDefaults.standard
    
    var memos:[String] = [""]
    var memoTitle:String!
    
    
    //画面が表示された時、設定値を反映させる
    override func viewWillAppear(_ animated: Bool){
        // はじめの状態をfalseにしておく.
        dateTapSwitch.isOn = false
        koteiSwitch.isOn = false
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "dateSwitchFlag") != nil{
            dateTapSwitch.isOn = myDefault.object(forKey: "dateSwitchFlag") as! Bool
        }
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "koteiSwitchFlag") != nil{
            koteiSwitch.isOn = myDefault.object(forKey: "koteiSwitchFlag")as! Bool
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // newTextFieldにプレスフォルダーを設定
        newTextField.placeholder = "新規登録"
        if newTextField.text == "" {
            newTableView.isHidden = true
        }else{
            newTableView.isHidden = false
        }
        
        readMemoData()
        createDatePicker()
    }
    
    
    func createDatePicker(){
        
        //dateTextFieldに現在日時を設定
        // 日時をラベルに表示する
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .full
        formatter.dateStyle = .full
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMMHHmm", options: 0, locale: Locale(identifier: "ja_JP"))

        self.dateTextField.text = "\(formatter.string(from: now))"
        
        //baseViewの設定-------------------------------
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.showDateSelected(sender:)), for: .valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        // ②日本の日付表示形式にする
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        
        dateTextField.inputView = datePicker
        
        // UIToolBarの設定
        var toolBar:UIToolbar!
        toolBar = UIToolbar(frame: CGRect(
            x:0,
            y:self.view.bounds.height/6,
            width:self.view.bounds.width,
            height:35
        ))
        toolBar.layer.position = CGPoint(x: 10, y: 100)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.closeBaseView(sender:)))
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [flexibleItem,toolBarBtn]
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    // coreDataの読み込み memoにappendしてる
    func readMemoData(){
        
        //配列の初期化
        memos = []
        
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //データを取得するエンティティの指定
//        <>の中はモデルファイルで指定したエンティティ名
       let query:NSFetchRequest<Memo> = Memo.fetchRequest()

        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //取得したデータを、デバックエリアにループで表示
            print(fetchResults.count)

            for result: AnyObject in fetchResults{
                let memo :String = result.value(forKey: "content") as! String

                print("memo:\(memo)")

                memos.append(memo)
            }
            memos.append("")
        } catch  {
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //行数の決定
        readMemoData()
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewCustumCell
        cell.tableView = newTableView
        cell.newTextFieldCell.text = memos[indexPath.row]
        
        return cell
    }
    
    func saveTitle() {
        if newTextField.text != "" {
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
    }
    
    //title完了ボタンを押した時に発動
    @IBAction func titleCompleteBtn(_ sender: UIButton) {
        saveTitle()
        newTableView.isHidden = false
    }
    
    //koteiSwitchスイッチの状態が変わった時に発動
    @IBAction func koteiSwitch(_ sender: UISwitch) {
        //スイッチの状態を保存
        //set(保存したい値、forKey:保存した値を取り出す時に指定する名前)
        myDefault.set(sender.isOn,forKey: "koteiSwitchFlag")
        
        //即保存させる（これがないと、値が保存されていない時があります）
        myDefault.synchronize()
    }
    
    //    DatePickerで日付が選択されたとき、textFieldにyyyy/MM/ddの形で選択された日付を表示する
    @objc func showDateSelected(sender:UIDatePicker){

        //フォーマットの設定
        print(sender.date)

        let df = DateFormatter()
        df.dateFormat = "yyyy年 MM月 dd日 HH : mm"
        
        //選択された日付を日付型から文字列に変換

        let strSelectedDate = df.string(from: sender.date)

        dateTextField.text = strSelectedDate

        //日付のTextFieldに変換した文字列を表示

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale(identifier: "ja_JP"))
        print(formatter.string(from: Date())) // 日

    }


    //baseViewのCloseボタンが押されたとき発動する

    @objc func closeBaseView(sender: UIButton){
        dateTextField.resignFirstResponder()
    }
    
    @IBAction func dateSwitch(_ sender: UISwitch) {
    
        dateTextField.resignFirstResponder()
        //isOn...Switchのオン/オフを表すプロパティ（Bool型）
        if sender.isOn == true {
            print("スイッチオン")
            // dateTextFieldを出す
            dateTextField.isHidden = false
        }else {
            print("スイッチオフ")
            // dateTextFieldを消す
            dateTextField.isHidden = true
        }
        
        //スイッチの状態を保存
        //set(保存したい値、forKey:保存した値を取り出す時に指定する名前)
        myDefault.set(sender.isOn,forKey: "dateSwitchFlag")
        //即保存させる（これがないと、値が保存されていない時があります）
        myDefault.synchronize()
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
