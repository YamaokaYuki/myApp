//
//  ViewController.swift
//  myApp2
//
//  Created by 山岡由季 on 2018/01/31.
//  Copyright © 2018年 山岡由季. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
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
        
      
        

        
    }
    
    //myTextFieldリターンキーが押された時にキーボードが下がる
    @IBAction func tapReturn(_ sender: UITextField) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

