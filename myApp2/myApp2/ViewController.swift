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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var functionAlerts:[String] = []
    
    //表示する個数の設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルオブジェクトの作成
        let cell:CustumCell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CustumCell
        
        //各プロパティに値を設定
        
        
        cell.myTextField.text = ""
        
        //背景色の設定
        cell.backgroundColor = UIColor.orange
        
        //作成したcellオブジェクトを戻り値として返す
        return cell
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        readPlist()
        print(functionAlerts)
        // ユーザーが使用した回数を保存
        let myDefault = UserDefaults.standard
        let c = myDefault.integer(forKey: "count")
        myDefault.set(c + 1, forKey: "count")
        
        print(c)
        
        let r = Int(arc4random()) % functionAlerts.count
        
//        for functionAlert in functionAlerts{
//            print(functionAlert)
//        }

        
        //機能アラートを作成
        let alert = UIAlertController(title: "こんな機能があるよ", message:functionAlerts[r], preferredStyle: .alert)
        
        //アラートにOKボタンを追加
        //handler:OKボタンが押された時に行いたい処理を指定する場所
        //nilをセットすると、何も動作しない
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: {Aaction in
            print("OK押されました")
            
        }))
        
        //アラートを表示
        present(alert, animated: true, completion: nil)
        
        
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
    
    //myTextFieldリターンキーが押された時にキーボードが下がる
    @IBAction func tapReturn(_ sender: UITextField) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

