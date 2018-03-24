//
//  ViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/01/31.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Instructions
import CoreData
import Hue//色変える
import SCLAlertView//褒めるポップアップ用
import UserNotifications//期日アラーム用

var functionAlerts:[String] = []


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating {
    
    var titles:[Dictionary<String,Any>] = []
    var selectedTitleId:String!
    var selectedTitle:String!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var addListBtn: UIBarButtonItem!
    @IBOutlet weak var setButton: UIBarButtonItem!
    
    var priorityArray:[Int] = []

    let colorlist = [UIColor(hex: "#0084ff"),UIColor(hex: "#85c8ff"),UIColor(hex: "#bfe2ff"),UIColor.white]

    var selectedNum:Int!
    
    //検索バーに関わるもの
    var searchResults:[Dictionary<String,Any>] = []
    var tableView: UITableView!
    var searchController = UISearchController()
    let sclAlert:SCLAlertView = SCLAlertView()
    
    override func viewWillAppear(_ animated: Bool) {
        readTitle()
        toDoListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readPlist()
        readTitle()
        setupSearchBar()
        
        setButton.image = UIImage.fontAwesomeIcon(
            name: .cog,
            textColor: UIColor.gray,
            size: CGSize(width: 35, height: 35)
        )
        
        toDoListTableView.separatorColor = UIColor.white
        toDoListTableView.rowHeight = 70.0;
        
        if myDefault.object(forKey: "commentSwitchFlag") == nil{
            myDefault.set(true,forKey: "commentSwitchFlag")
        }
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        

    }// viewDidRoad終了
    
    
    
    
    func readPlist() {
        //ファイルのパスを取得
        let filePath = Bundle.main.path(forResource: "functionAlert", ofType: "plist")

        //ファイルの内容を読み込んでディクショナリー型に代入
        let dic = NSDictionary(contentsOfFile: filePath!)

        //TableViewで扱いやすい形（エリア名の入ってる配列）を作成
        for(_,value) in dic!{
            functionAlerts.append(value as! String)
        }
    }
    
    //<サーチバー作成>
    private func setupSearchBar() {
        if (navigationController?.navigationBar.bounds) != nil {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.searchBar.sizeToFit()
            searchController.dimsBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            navigationItem.titleView = searchController.searchBar
        }
    }
    
    
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
        
        let sortDescripter = NSSortDescriptor(key: "priority", ascending: false)//ascendind:true 昇順、false 降順
        query.sortDescriptors = [sortDescripter]

        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            var array:[Int] = []
            //取得したデータを、デバックエリアにループで表示
            for result in fetchResults {

                let titleData = [
                    "title": result.title!,
                    "id":result.id!,
                    "priority":result.priority,
                    "dueDate":result.dueDate,
                    "check":result.check
                    ] as [String : Any]
                titles.append(titleData)
                
                array.append(Int(result.priority))
                }
            let orderedSet = NSOrderedSet(array: array)
            priorityArray = orderedSet.array as! [Int]
            self.toDoListTableView.reloadData()
            
        } catch  {
        }
    }

    
    //表示する個数の設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //検索バー
        if searchController.isActive {
            return searchResults.count
        } else {
            return titles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルオブジェクトの作成
        let cell:CustumCell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CustumCell
        //各プロパティに値を設定
        cell.toDoTitle.text = titles[indexPath.row]["title"] as? String
        let checkNum = titles[indexPath.row]["check"] as? Int16
        cell.toDoId = titles[indexPath.row]["id"] as? String
        
        if checkNum == 0{
            cell.checkBtn.tintColor = UIColor.lightGray
        } else if checkNum == 1{
            cell.checkBtn.tintColor = UIColor.blue
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 35
        paragraphStyle.headIndent = 35
        paragraphStyle.tailIndent = -20
        
        let attributedString = NSAttributedString(string: titles[indexPath.row]["title"] as! String /* long text */, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        cell.toDoTitle.attributedText = attributedString
        
        
        //priorityNumの番号によって色を変更する
        let priority:Int = Int(titles[indexPath.row]["priority"] as! Int16)
        
        for n in 0...priorityArray.count - 1 {
            if priority == priorityArray[n] {
                cell.contentView.backgroundColor = colorlist[n]
            }
        }

        
        if priority == 3 {
            cell.contentView.backgroundColor = UIColor(hex: "#0084ff")
        }else if priority == 2{
            cell.contentView.backgroundColor = UIColor(hex: "#85c8ff")
        }else if priority == 1 {
            cell.contentView.backgroundColor = UIColor(hex: "#bfe2ff")
        }else if priority == 0 {
            cell.contentView.backgroundColor = UIColor.white
        }
    
        if searchController.isActive {
            cell.toDoTitle!.text = "\(searchResults[indexPath.row]["title"]!)"
        }else{
            cell.toDoTitle!.text = "\(titles[indexPath.row]["title"]!)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //選択された行番号をメンバ変数に保存（セグエを使って画面移動する時に発動するメソッドが違うもののため、そこで使えるようにする）
        selectedTitleId = titles[indexPath.row]["id"] as! String
        selectedTitle = titles[indexPath.row]["title"] as! String

        selectedNum = indexPath.row
        
        //セグエの名前を指定して、画面遷移処理を発動（付ける名前はeditMemoViewController。ストーリーボード上でidentifierで指定）
        performSegue(withIdentifier: "editViewController", sender: nil)

    }
    

    
    //セグエを使って画面遷移してる時発動
    //サーチバーのキーボードを画面遷移のタイミングで下げる
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchController.searchBar.resignFirstResponder()

        //複数セグエがある場合、segue.identifierで判別可能
        //移動先の画面のインスタンスを取得
        //segue.destination セグエが持っている、目的地（移動先の画面）
        //as ダウンキャスト変換 広い範囲から限定したデータ型へ型変換するときに使用
        //as! 型変換して、オプショナル型からデータを取り出す
        if segue.identifier == "editViewController"{
            let dvc:secondViewController = segue.destination as! secondViewController
            //移動先の画面のプロパティに、選択された行番号を代入（これで、DetailViewControllerに選択された行番号が渡せる）
            dvc.passedTitleId = selectedTitleId
            dvc.passedTitle = selectedTitle
            dvc.todoData = titles[selectedNum]
        }
    }
    
    
    //<セルの削除>
    func memoDelete(titleId:String){
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        //全部取得する
        let query:NSFetchRequest<Memo> = Memo.fetchRequest()
        
        //絞り込み検索（更新したいデータを取得する）
        //ここで取得したいデータをとるためのコードを書く
        let  r_idPredicate = NSPredicate(format: "titleId = %@", titleId)
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
                if record.value(forKey: "titleId") as! String == titleId {
                    viewContext.delete(record)
                }
                
            }
            //レコード（行）の即時保存
            try viewContext.save()
            
        } catch {
            print("DBへの保存に失敗しました")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let titleData = titles[indexPath.row]
            self.titles.remove(at: indexPath.row)
            toDoListTableView.deleteRows(at: [indexPath], with: .fade)
            
            //AppDelegateを使う準備をしておく
            let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
            
            //エンティティを操作するためのオブジェクトを作成
            let viewContext = appD.persistentContainer.viewContext
            
            //データを取得するエンティティの指定
            //<>の中はモデルファイルで指定したエンティティ名
            let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            
            do {
                //削除したいデータの一括取得
                let fetchResults = try viewContext.fetch(query)
                
                //取得したデータを、削除指示
                
                for result: AnyObject in fetchResults{
                    let record = result as! NSManagedObject//1行分のデータ
                    if record.value(forKey: "id") as! String == titleData["id"] as! String {
                        viewContext.delete(record)
                    }
                }
                memoDelete(titleId: titleData["id"] as! String)
                
                let identifiers = [titleData["id"] as! String]
                UNUserNotificationCenter.current().removeNotificationsCompletely(withIdentifiers: identifiers)
                    
                
                
                //削除した状態を保存
                try viewContext.save()
                
            } catch  {
                
            }
            
            // 0から3のpriorityの種類？
            if titles.count != 0 {
                for n in 0...3 {
                    //　すべてのタイトルのデータに対して0-3の種類があるかチェック
                    var flag:Bool = false
                    for m in 0...titles.count - 1 {
                        if Int(titles[m]["priority"] as! Int16) == n {
                            flag = true
                        }
                    }
                    
                    if flag == false {
                        // 色変える
                        readTitle()
                        toDoListTableView.reloadData()
                        break
                    }
                }
            }
        }
    }
    
    // 文字が入力される度に呼ばれる
    func updateSearchResults(for searchController: UISearchController) {
        
        self.searchResults = titles.filter{
            // 大文字と小文字を区別せずに検索
            ($0["title"] as! String).lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        self.toDoListTableView.reloadData()
    }
    
    
    
    @IBAction func priorityBtn(_ sender: UIButton) {
        readTitle()
    }
    
    @IBAction func timeBtn(_ sender: UIButton) {
        titles = []
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //データを取得するエンティティの指定
        //<>の中はモデルファイルで指定したエンティティ名
        let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        let sortDescripter = NSSortDescriptor(key: "dueDate", ascending: true)//ascendind:true 昇順、false 降順です
        query.sortDescriptors = [sortDescripter]
        
        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            var array:[Int] = []
            //取得したデータを、デバックエリアにループで表示
            for result in fetchResults {
                let titleData = [
                    "title": result.title!,
                    "id":result.id!,
                    "priority":result.priority,
                    "dueDate":result.dueDate,
                    "check":result.check
                    ] as [String : Any]
                titles.append(titleData)
                
                array.append(Int(result.priority))
                
            }
            let orderedSet = NSOrderedSet(array: array)
            priorityArray = orderedSet.array as! [Int]

            self.toDoListTableView.reloadData()
            
        } catch  {
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension UNUserNotificationCenter {
    func removeNotificationsCompletely(withIdentifiers identifiers: [String]) {
        self.removePendingNotificationRequests(withIdentifiers: identifiers)
        self.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
}



