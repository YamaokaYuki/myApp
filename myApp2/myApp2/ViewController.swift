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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var functionAlerts:[String] = []
    var titles:[String] = []
    var searchBar: UISearchBar!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var addListBtn: UIBarButtonItem!
    @IBOutlet weak var setButton: UIBarButtonItem!
    
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
        
        
        
//        print(functionAlerts)
        // ユーザーが使用した回数を保存（アラート用）
//        let myDefault = UserDefaults.standard
//        let c = myDefault.integer(forKey: "count")
//        myDefault.set(c + 1, forKey: "count")
//
//        print(c)
        
//        let r = Int(arc4random()) % functionAlerts.count
        
//        for functionAlert in functionAlerts{
//            print(functionAlert)
//        }
        


        
        //機能アラートを作成
////        let alert = UIAlertController(title: "こんな機能があるよ", message:functionAlerts[r], preferredStyle: .alert)
//
//        //アラートにOKボタンを追加
//        //handler:OKボタンが押された時に行いたい処理を指定する場所
//        //nilをセットすると、何も動作しない
//        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: {Aaction in
//            print("OK押されました")
//
//        }))
        
        //アラートを表示
        //present(alert, animated: true, completion: nil)
        
        
    }
    
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
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            //searchBar.showsCancelButton = true
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    //サーチバーのキーボードを画面遷移のタイミングで下げる
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.resignFirstResponder()
    }
    
    
  
    
    //myTextFieldリターンキーが押された時にキーボードが下がる
//    @IBAction func tapReturn(_ sender: UITextField) {
//    }
    
    
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
                titles.append(title)
            }
        } catch  {
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
        //背景色の設定
//        cell.backgroundColor = UIColor.orange
        //作成したcellオブジェクトを戻り値として返す
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected:\(indexPath.row)")
        // 選択したタイトルが取得できる
        print(titles[indexPath.row])
        
        // ページ遷移

    
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
                    print(type(of: result))
                    let record = result as! NSManagedObject//1行分のデータ
                    print(record.value(forKey: "title"))
                    print(type(of: record.objectID))//使い方調べるobjectIDが使えたらtitleIdがいらない
                    print("a")
                    print(indexPath.row)
                    if record.value(forKey: "title") as! String == titles[indexPath.row] {
                        viewContext.delete(record)
                        
                       
                    }
                    
                }
                
                self.titles.remove(at: indexPath.row)
                toDoListTableView.deleteRows(at: [indexPath], with: .fade)
                
                
                
                
                //削除した状態を保存
                try viewContext.save()
                
            } catch  {
                
            }
            
        }
        
        
        
        
        //<削除後コメント>
        let r = Int(arc4random()) % functionAlerts.count
        print(functionAlerts[r])

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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

