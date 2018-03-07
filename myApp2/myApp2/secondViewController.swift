///
//  secondViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/02/03.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import CoreData //CoreData使う時絶対に必要
import DatePickerDialog
import Hue
import UserNotifications//期日アラーム用
import IQKeyboardManagerSwift//キーボード用

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var newTableView: UITableView!
    @IBOutlet weak var newTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    
    // okayu 色作成
    let oneBtnColor:UIColor = UIColor(hue: 206/359, saturation: 1, brightness: 1, alpha: 1)
    let twoBtnColor:UIColor = UIColor(hue: 207/359, saturation: 0.48, brightness: 1, alpha: 1)
    let threeBtnColor:UIColor = UIColor(hue: 207/359, saturation: 0.24, brightness: 1, alpha: 1)
    let btnGray:UIColor = UIColor(hue: 206/359, saturation: 0, brightness: 0.8, alpha: 1)
    
    var dueDate:Date!
    
    var passedTitleId = ""
    var passedTitle = ""
    var todoData:Dictionary<String,Any>!
    let myDefault = UserDefaults.standard
    
    var memos:[String] = []
    
    var priorityNum:Int!
    var memoTitle:String!
    var tmpText:String!
    var titleTag = -1
    var cells:[NewCustumCell] = []
    var saveBtn:UIBarButtonItem!
    let colorDefault = UserDefaults.standard
    var cellHeight:CGFloat = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //------優先ボタン状態保存処理----------------
      

        if todoData != nil {

            let num = (todoData["priority"]!) as! Int16
            priorityNum = Int(num)

            allGray()
            if priorityNum == 0{
                oneBtn.backgroundColor = oneBtnColor
                twoBtn.backgroundColor = twoBtnColor
                threeBtn.backgroundColor = threeBtnColor
            }else if priorityNum == 1{
                threeBtn.backgroundColor = threeBtnColor
            }else if priorityNum == 2{
                twoBtn.backgroundColor = twoBtnColor
            }else if priorityNum == 3{
                oneBtn.backgroundColor = oneBtnColor
            }
            
            //dueDateを表示し保存するためのコード
            //dueDateをDate型として指定する
            if dueDate != nil {
                let dueDate = todoData["dueDate"] as! Date
                //dueDateを表示するためにdate型からstring型に直してあげるのがdateformatter
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
                self.dateTextField.text = "\(formatter.string(from: dueDate))"
                //編集がされなかったときのために予め保存されている物を残しておく
                self.dueDate = dueDate
            }
            
        }
        
        //------優先ボタン状態保存処理 終了----------------
        newTableView.delegate = self
        newTextField.delegate = self
        newTextField.tag = titleTag
        dateTextField.delegate = self
        

        // タイトルと詳細メモに値をいれる
        if passedTitleId != "" {
            readMemoData()

            newTextField.text = passedTitle
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print(urls[urls.count-1] as URL)

        }

        // newTextFieldにプレスフォルダーを設定
        newTextField.placeholder = "タイトル入力"
        if newTextField.text == "" {
            newTableView.isHidden = true
        }else{
            newTableView.isHidden = false
        }
        
        //dateTextFieldにプレスフォルダーを設定する
         dateTextField.placeholder = "アラート時刻"
        
        //期限通知の許可を出す
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // BarButtonItem保存を作成する.
        saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveButton(sender:)))
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        saveBtn.isEnabled = false
        if newTextField.text == "" {
            saveBtn.isEnabled = false
        }else{
            saveBtn.isEnabled = true
        }
        
       // BarButtonItemキャンセルを作成する.
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action:#selector(self.backButton(sender:)))
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setLeftBarButton(cancelBtn, animated: true)
        
        //ボタン丸角
        oneBtn.layer.cornerRadius = 7.0;
        oneBtn.clipsToBounds = false;
        
        twoBtn.layer.cornerRadius = 7.0;
        twoBtn.clipsToBounds = true;
        
        threeBtn.layer.cornerRadius = 7.0;
        threeBtn.clipsToBounds = true;
        
        //(1)文字数制限をかけるテキストフィールドを監視対象にする
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: NSNotification.Name.UITextFieldTextDidChange,
            object: newTextField)
    }//viewDidLoad終わり
    
    
    //(2)テキストフィールドの入力イベントを監視し、変更があった場合に指定文字数(ここでは20文字)を超えた文字の入力をさせいない
    @objc private func textFieldDidChange(notification: NSNotification) {
        let textFieldString = notification.object as! UITextField
        if let text = textFieldString.text {
            if text.characters.count > 15 {
                newTextField.text = text.substring(to: text.index(text.startIndex, offsetBy: 15))
            }
        }
    }
    
    
    // BarButtonItemキャンセルの前画面に戻す処理.
    @objc func backButton(sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
    }
    // BarButtonItem保存の前画面に戻す処理.
    @objc func saveButton(sender: UIBarButtonItem){

        _ = navigationController?.popViewController(animated: true)
        
        //ここで区別するidがある無し
        if passedTitleId == ""{
            
        
            for n in 0...cells.count - 1{
                textFieldDidEndEditing(cells[n].newTextFieldCell)
            }
            
            saveTitle()
            setDueDate()
            
        }else{
            
            //リターンキーが押されたとき及びカーソルが外れた時(キーボードが下がった時)に発動する処理をすべてのセルで行ってあげる処理
            for n in 0...cells.count - 1{
//                cells[n].newTextFieldCell.becomeFirstResponder()
                textFieldDidEndEditing(cells[n].newTextFieldCell)
            }
            titleUpdate()
            memoDelete()
            memoEditCreate()
            setDueDate()

        }
    }

    //titleのアップデート
    func titleUpdate(){
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext

        //どのエンティティからdataを取得してくるか設定
        //全部取得する
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()

        //絞り込み検索（更新したいデータを取得する）
        //ここで取得したいデータをとるためのコードを書く
        let  r_idPredicate = NSPredicate(format: "id = %@", passedTitleId)
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
                record.setValue(newTextField.text, forKey: "title")
                record.setValue(Date(), forKey: "saveDate")
                
                if dateTextField.text != "" {
                    record.setValue(dueDate, forKey: "dueDate")
                }
                record.setValue(priorityNum, forKey: "priority")

                do{
                    //レコード（行）の即時保存
                    try viewContext.save()

                } catch {
                     print("DBへの保存に失敗しました")
                }
            }
        }catch{
            
        }
    }
    
    
    //Memoからタイトルのidと等しいレコードを削除
    func memoDelete(){

        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext

        //どのエンティティからdataを取得してくるか設定
        //全部取得する
        let query:NSFetchRequest<Memo> = Memo.fetchRequest()

        //絞り込み検索（更新したいデータを取得する）
        //ここで取得したいデータをとるためのコードを書く
        let  r_idPredicate = NSPredicate(format: "titleId = %@", passedTitleId)
        query.predicate = r_idPredicate

        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)

            //データの取得
            for result: AnyObject in fetchResults {

                //更新する準備（NSManagedObjectにダウンキャスト型変換)
                //recordがひとつのセット
                let record = result as! NSManagedObject
                //削除したいデータのセット
                //ここが問題
                if record.value(forKey: "titleId") as! String == passedTitleId {
                    viewContext.delete(record)
                }

            }
                    //レコード（行）の即時保存
                    try viewContext.save()

                } catch {
                    print("DBへの保存に失敗しました")
        }
    }
    
    func memoEditCreate(){
        
        if memos.count != 0 {
            //AppDelegateを使う準備をしておく
            let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
            
            //エンティティを操作するためのオブジェクトを作成
            let viewContext = appD.persistentContainer.viewContext
            
            for n in 0...memos.count - 1 {

                //Memoエンティティオブジェクトを作成
                //forEntityNameは、モデルファイルで決めたエンティティ名（大文字小文字合わせる）
                let Memo = NSEntityDescription.entity(forEntityName: "Memo", in: viewContext)

                //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
                let memoData = NSManagedObject(entity: Memo!, insertInto: viewContext)

                //レコードオブジェクトに値のセット
                memoData.setValue(passedTitleId, forKey: "titleId")
                memoData.setValue(memos[n], forKey: "content")

                //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
                do {
                    //レコード（行）の即時保存
                    try viewContext.save()
                } catch  {
                    print("DBへの保存に失敗しました")
                }
            }

        }
    }//memoEditCreate
    
    

    
    
    
    //日時表示欄
    func createDatePicker(){
        
        let datePickerDialog = DatePickerDialog(
            locale: Locale(identifier: "ja_JP"),
            showCancelButton: true
        )
        datePickerDialog.datePicker.minimumDate = Date()

        datePickerDialog.show("期限", doneButtonTitle: "決定", cancelButtonTitle: "キャンセル", minimumDate: Date(), datePickerMode: .dateAndTime) {
            (date) -> Void in
            if let dt = date {
                self.dueDate = dt
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
//                print(formatter.string(from: dt))
                self.dateTextField.text = "\(formatter.string(from: dt))"
                
                
            }
        }
        
        
    }
    
    // coreDataの読み込み memoにappendしてる
    func readMemoData(){
        print(#function)
        //配列の初期化
        memos = []

        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate

        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext

        //データを取得するエンティティの指定
        //<>の中はモデルファイルで指定したエンティティ名
       let query:NSFetchRequest<Memo> = Memo.fetchRequest()

        ////===== 絞り込み =====
        let r_idPredicate = NSPredicate(format: "titleId = %@",passedTitleId)
        query.predicate = r_idPredicate

        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //取得したデータを、デバックエリアにループで表示


            for result: AnyObject in fetchResults{
                
                let memo :String = result.value(forKey: "content") as! String
                let memoTitle :String = result.value(forKey: "titleId") as! String
                memos.append(memo)
            }
            newTableView.reloadData()
        } catch  {
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //行数の決定
        return memos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewCustumCell
        cell.tableView = newTableView
        //セルの中にあるnewTextFieldCellとviewControllerを一体化
        cell.newTextFieldCell.delegate = self

        cell.newTextFieldCell.tag = indexPath.row
        if indexPath.row == memos.count {
            cell.newTextFieldCell.text = ""
            
            if memos.count != 0 {
                cell.newTextFieldCell.becomeFirstResponder()
            }
            
        }else {
            cell.newTextFieldCell.text = memos[indexPath.row]
        }
 
        cells.append(cell)
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
            
            let uuid:String = NSUUID().uuidString
            
            //レコードオブジェクトに値のセット
            newRecord.setValue(newTextField.text, forKey: "title")
            newRecord.setValue(uuid, forKey: "id")
            newRecord.setValue(Date(), forKey: "saveDate")
            newRecord.setValue(priorityNum, forKey: "priority")

            if dateTextField.text != "" {
                newRecord.setValue(dueDate, forKey: "dueDate")
            }
            
            //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
            do {
                //レコード（行）の即時保存
                try viewContext.save()
            } catch  {
                print("DBへの保存に失敗しました")
            }
            print(#function,"メモのセーブ")
            if memos.count != 0 {
                for n in 0...memos.count - 1 {
                    //Memoエンティティオブジェクトを作成
                    //forEntityNameは、モデルファイルで決めたエンティティ名（大文字小文字合わせる）
                    let Memo = NSEntityDescription.entity(forEntityName: "Memo", in: viewContext)
                    
                    //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
                    let memoData = NSManagedObject(entity: Memo!, insertInto: viewContext)
                    
                    //レコードオブジェクトに値のセット
                    memoData.setValue(uuid, forKey: "titleId")
                    memoData.setValue(memos[n], forKey: "content")
                    
                    //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
                    do {
                        //レコード（行）の即時保存
                        try viewContext.save()
                    } catch  {
                        print("DBへの保存に失敗しました")
                    }
                }
            }
        }

    }
    
    //title完了ボタンを押した時に発動
    @IBAction func titleCompleteBtn(_ sender: UIButton) {
        
        if newTextField.text != "" {
            newTableView.isHidden = false
            tmpText = newTextField.text
            newTextField.resignFirstResponder()
        }else{
            newTextField.text = tmpText
        }
        
    }
    

    func textFieldDidBeginEditing(_ TextField: UITextField) {
        if TextField == self.dateTextField {
            createDatePicker()
        }
    }
    
    
    //textFieldのリターンキーが押された時に発動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // タイトルのテキストフィールドではなく、テキストフィールドが空ではないとき
        if textField.tag != titleTag && textField.text != "" {
           
            
            // cellのtagとmemos.countが一致　→ 新規の詳細メモ
            if memos.count == textField.tag {
            }else{
            
                self.memos[textField.tag] = textField.text!
            }
            
            
            //memosとtitleタグの番号があってない　表示用の配列を別で作る

            cells = []
            newTableView.reloadData()
        }

       
        // 詳細メモが空のとき、復活
        if textField.text == "" && textField.tag != titleTag  {
            cells = []
            newTableView.reloadData()
        }
        
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        //return false
        return true
    }


    
    // テキストフィールドから離れた時に発動
    func textFieldDidEndEditing(_ textField: UITextField) {

        //詳細メモが空のままフォーカスが外れた時に復活
        if textField.tag != titleTag && textField.text == "" {
            newTableView.reloadData()
        }

        //titleが空だった時に前に記入したものを復活させる
        if textField.tag == titleTag && textField.text == "" {
            newTextField.text = tmpText
        }
        
        if textField.tag != titleTag && textField.text != "" {
            
            if textField.tag == memos.count{
                memos.append(textField.text!)
            }else{
                memos[textField.tag] = textField.text!
            }
        }
        
        //saveBtn有効にする
        if newTextField.text == "" {
            saveBtn.isEnabled = false
        }else{
            saveBtn.isEnabled = true
        }
        
    }
    
    
    //<削除ボタン作成>
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //詳細メモが空のままフォーカスが外れた時に復活
            
            newTableView.reloadData()
            self.memos.remove(at: indexPath.row)
            newTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    
    
    //行を編集するための関数（メモがからの時は削除ボタンを出なくする）
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.cellForRow(at: indexPath) != nil {
            let cell:NewCustumCell = tableView.cellForRow(at: indexPath) as! NewCustumCell
            
            if cell.newTextFieldCell.text == "" || cell.newTextFieldCell.isEditing == true{
                return false
            }else{
                return true
            }
            
        }
        
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        passedTitleId = ""
    }
    
    
    //------------------ボタン関数--------------------------
    @IBAction func firstBtn(_ sender: UIButton) {
        allGray()
        if priorityNum == 3{
            resetColorBtn()
        }else {
            sender.backgroundColor = oneBtnColor
            priorityNum = 3
        }
    }
    

    @IBAction func secondBtn(_ sender: UIButton) {
        
        
        allGray()
        if priorityNum == 2{
            resetColorBtn()
        }else {
            sender.backgroundColor = twoBtnColor
            priorityNum = 2
        }
    }
    
    @IBAction func thirdBtn(_ sender: UIButton) {

        
        allGray()
        if priorityNum == 1 {
            resetColorBtn()
        }else {
            sender.backgroundColor = threeBtnColor
            priorityNum = 1
        }
    }
    
    func resetColorBtn(){
        
        priorityNum = 0
        
        oneBtn.backgroundColor = oneBtnColor
        twoBtn.backgroundColor = twoBtnColor
        threeBtn.backgroundColor = threeBtnColor
    }
    
    
    func allGray(){
        oneBtn.backgroundColor = btnGray
        twoBtn.backgroundColor = btnGray
        threeBtn.backgroundColor = btnGray
    }
    
    //----------------ボタン関数 終了---------------------------------
    


    
    
//    期限アラーム作成
    func setDueDate() {
        if dateTextField.text != "" {
            //文字列変換
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd hh:mm"
            let strDate = df.string(from: self.dueDate)

            // Notificatiのインスタンス生成
            let content = UNMutableNotificationContent()

            // タイトルを設定する
            content.title = newTextField.text!

            // 通知の本文です
            content.body = "\(strDate)"

            // デフォルトの音に設定します
            content.sound = UNNotificationSound.default()

            //着火時間の設定

            var setDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: self.dueDate)
            setDateComponents.second = 0

            var dateComponents = DateComponents()
            dateComponents.year = setDateComponents.year!
            dateComponents.month = setDateComponents.month!
            dateComponents.day = setDateComponents.day!

            dateComponents.hour = setDateComponents.hour!
            dateComponents.minute = setDateComponents.minute!
            dateComponents.second = 0


            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            //
            // Requestを生成する。idには通知IDを設定する
            let request = UNNotificationRequest.init(identifier: "ID_SetDayAndTime", content: content, trigger: calendarTrigger)

            // Noticationを発行する.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                print(error ?? "\(setDateComponents.year!)年\(setDateComponents.month!)月\(setDateComponents.day!)日\(setDateComponents.hour!)時\(setDateComponents.minute!)分発動！")


            }
        }

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}



