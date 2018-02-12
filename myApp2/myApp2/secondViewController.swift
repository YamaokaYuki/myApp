//
//  secondViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/02/03.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import CoreData //CoreData使う時絶対に必要

var titleId:Int64!

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var newTableView: UITableView!
    @IBOutlet weak var newTextField: UITextField!
    @IBOutlet weak var dateTapSwitch: UISwitch!
    @IBOutlet weak var koteiSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    let myDefault = UserDefaults.standard
    
    var memos:[String] = ["aaa","bbb","ccc"]
    var memoTitle:String!
    var tmpText:String!
    var titleTag = -1
    var cells:[NewCustumCell] = []
    
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
        newTableView.delegate = self
        newTextField.delegate = self
        newTextField.tag = titleTag
        // newTextFieldにプレスフォルダーを設定
        newTextField.placeholder = "新規登録"
        newTextField.text = "title1"
        if newTextField.text == "" {
            newTableView.isHidden = true
        }else{
            newTableView.isHidden = false
        }
        
        // readMemoData()
        createDatePicker()
        
        
//        // BarButtonItem保存を作成する.
        let saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveButton(sender:)))
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
//
//
//        // BarButtonItemキャンセルを作成する.
//
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action:#selector(self.backButton(sender:)))
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setLeftBarButton(cancelBtn, animated: true)

    }
    
    
    @objc func backButton(sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButton(sender: UIBarButtonItem){
        print(self.memos)
        _ = navigationController?.popViewController(animated: true)
    }

    //日時表示欄
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //行数の決定
        // readMemoData()
        return memos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell num",indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewCustumCell
        cell.tableView = newTableView
        //セルの中にあるnewTextFieldCellとviewControllerを一体化
        cell.newTextFieldCell.delegate = self

        cell.newTextFieldCell.tag = indexPath.row
        print(indexPath.row)
        if indexPath.row == memos.count {
            cell.newTextFieldCell.text = ""
            
            if memos.count != 0 {
                cell.newTextFieldCell.becomeFirstResponder()
            }
            
        }else {
            cell.newTextFieldCell.text = memos[indexPath.row]
        }
        // ここがうまくいけば、いけるはず
//        if cells[indexPath.row] {
//            cells[indexPath.row] = cell
//        }else {
//            cells.append(cell)
//        }
//        print(cells.count)
        
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
            
            //レコードオブジェクトに値のセット
            newRecord.setValue(newTextField.text, forKey: "title")
//            newRecord.setValue(newTextField.text, forKey: "saveDate")
//            newRecord.setValue(newTextField.text, forKey: "priority")
//            newRecord.setValue(newTextField.text, forKey: "id")
//            newRecord.setValue(newTextField.text, forKey: "dueDate")
            
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
        
        if newTextField.text != "" {
            newTableView.isHidden = false
            tmpText = newTextField.text
            newTextField.resignFirstResponder()
        }else{
            newTextField.text = tmpText
//            newTableView.isHidden = true
        }
        
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

        let df = DateFormatter()
        df.dateFormat = "yyyy年 MM月 dd日 HH : mm"
        
        //選択された日付を日付型から文字列に変換

        let strSelectedDate = df.string(from: sender.date)

        dateTextField.text = strSelectedDate

        //日付のTextFieldに変換した文字列を表示

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale(identifier: "ja_JP"))
        //print(formatter.string(from: Date())) // 日

    }


    //datepickerのCloseボタンが押されたとき発動する

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
//    @IBAction func newTextField(_ sender: UITextField) {
//    }
    
    //textFieldのリターンキーが押された時に発動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        // タイトルのテキストフィールドではなく、テキストフィールドが空ではないとき
        if textField.tag != titleTag && textField.text != "" {
            
            // cellのtagとmemos.countが一致　→ 新規の詳細メモ
            if memos.count == textField.tag {
//                 self.memos.append(textField.text!)
            }else{
                // 更新
                self.memos[textField.tag] = textField.text!
            }

            cells = []
            newTableView.reloadData()
        }

        // 詳細メモが空のとき、復活
        if textField.text == "" && textField.tag != titleTag  {
            cells = []
            newTableView.reloadData()
        }
        return true
    }

    //テキストフィールドの入力中に発動
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 詳細メモ　かつ　テキストフィールドが空でない場合
//        if textField.tag != titleTag && textField.text != "" {
//            // 全てのcellとmemosの比較をして、更新
//            for n in 0...cells.count - 1 {
//                print("cell count",cells.count)
//                print("memos count",memos.count)
//                // cells[n]が空だったら、むし
//                if cells[n].newTextFieldCell.text != "" {
//                    // 新規のメモの作成中に他のセルに移動した時、保存されていないので、空でない場合は、memosに保存
//                    if cells.count == memos.count + 1 && cells[cells.count - 1].newTextFieldCell.text! != ""{
//                        memos.append(cells[cells.count - 1].newTextFieldCell.text!)
//                    }else{
//                        // cellsのデータをそのまま、memosへ更新
//                        memos[n] = cells[n].newTextFieldCell.text!
//                    }
//                }
//            }
//        }
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
//            for n in 0...cells.count - 1 {
//                if cells[n].newTextFieldCell.text != "" {
//                    if cells.count == memos.count + 1 && cells[cells.count - 1].newTextFieldCell.text! != ""{
//                        memos.append(cells[cells.count - 1].newTextFieldCell.text!)
//                    }else{
//                        memos[n] = cells[n].newTextFieldCell.text!
//                    }
//                }
//            }
        }
        
    }
    
    //セルがふえたら、memosにアペンドしてあげる
    //セルが編集されたらそのセル番号を編集してあげる
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.memos.remove(at: indexPath.row)
            newTableView.deleteRows(at: [indexPath], with: .fade)
        }
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


//セルを配列に入れている、そのセルの配列とmemosの差を見て更新するように作っている
//セルの配列を作っているのはfunc tableView186です。セルを作っているところ
//しかし、そのデータが多くなったときはスクロールする必要があって、そうすると表示されているものしかセルを作らない
//その時memosとセルの配列の番号が合わなくなる

