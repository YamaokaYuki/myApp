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


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating {
    
    var functionAlerts:[String] = []
    var titles:[Dictionary<String,Any>] = []
    var selectedTitleId:String!
    var selectedTitle:String!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var addListBtn: UIBarButtonItem!
    @IBOutlet weak var setButton: UIBarButtonItem!
    var priorityArray:[Int64] = []
    let colorlist = [UIColor.white,UIColor(hex: "#bfe2ff"),UIColor(hex: "#85c8ff"),UIColor(hex: "#0084ff")]
    
    //検索バーに関わるもの
//    let PPAP:[String] = []
    var searchResults:[Dictionary<String,Any>] = []
    var tableView: UITableView!
    var searchController = UISearchController()

    
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
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
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
        
        let sortDescripter = NSSortDescriptor(key: "priority", ascending: false)//ascendind:true 昇順、false 降順です
        query.sortDescriptors = [sortDescripter]

        do {
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            var array:[Int64] = []
            //取得したデータを、デバックエリアにループで表示
            for result in fetchResults {
                let titleData = [
                    "title": result.title!,
                    "id":result.id,
                    "priority":result.priority
                    ] as [String : Any]
                titles.append(titleData)
                
                array.append(result.priority)
                
            }
            let orderedSet = NSOrderedSet(array: array)
            priorityArray = orderedSet.array as! [Int64]
            print(priorityArray)
            self.toDoListTableView.reloadData()
            
        } catch  {
        }
    }

    
    //表示する個数の設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titles.count
        
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
        
        //priorityNumの番号によって色を変更する
        //そのセルだけ
        let priority:Int64 = titles[indexPath.row]["priority"] as! Int64
        print("in cell",priorityArray)
        
        for n in 0...priorityArray.count - 1 {
            if priority == n {
                cell.contentView.backgroundColor = colorlist[n]
            }
        }

        if priority == 3 {
            cell.contentView.backgroundColor = UIColor(hex: "#0084ff")
        }else if priority == 2{
            cell.contentView.backgroundColor = UIColor(hex: "#85c8ff")
        }else if priority == 1 {
            cell.contentView.backgroundColor = UIColor(hex: "#bfe2ff")
        }
    
        //作成したcellオブジェクトを戻り値として返す
//        return cell
        
        //検索バーに関わるもの
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
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
        }
    }
    
    
    //<セルの削除>
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
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
                    if record.value(forKey: "id") as! String == titles[indexPath.row]["id"] as! String {
                        viewContext.delete(record)
                    }
                    
                }
                
                self.titles.remove(at: indexPath.row)
                
                // 0から3のpriorityの種類？
                //ここ直す
//                for n in 0...3 {
//                    //　すべてのタイトルのデータに対して0-3の種類があるかチェック
//
//                    var flag = false
//                    for m in 0...titles.count - 1 {
//                        if titles[m]["priority"] as! Int64 == n {
//                            flag = true
//                        }
//                    }
//                    
//                    if flag == false {
//                        // 色変える
//
////                        readTitle()
////                        toDoListTableView.reloadData()
//
//                    }
//                }
                
                toDoListTableView.deleteRows(at: [indexPath], with: .fade)
                
                //削除した状態を保存
                try viewContext.save()
                
            } catch  {
                
            }
            
        }
        
        
        
        
        //<削除後コメント>
        let r = Int(arc4random()) % functionAlerts.count
//        print(functionAlerts[r])

        //機能アラートを作成
        let alert = UIAlertController(title: "褒めの言葉", message:functionAlerts[r], preferredStyle: .alert)

        //アラートにOKボタンを追加
        //handler:OKボタンが押された時に行いたい処理を指定する場所
        //nilをセットすると、何も動作しない
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: {Aaction in
            print("OK押されました")

        }))

        //アラートを表示
        present(alert, animated: true, completion: nil)

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
            var array:[Int64] = []
            //取得したデータを、デバックエリアにループで表示
            for result in fetchResults {
                let titleData = [
                    "title": result.title!,
                    "id":result.id,
                    "priority":result.priority
                    ] as [String : Any]
                titles.append(titleData)
                
                array.append(result.priority)
                
            }
            let orderedSet = NSOrderedSet(array: array)
            priorityArray = orderedSet.array as! [Int64]
            print(priorityArray)
            self.toDoListTableView.reloadData()
            
        } catch  {
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

