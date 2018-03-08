

import UIKit

let myDefault = UserDefaults.standard

class setViewController: UIViewController {
    
    @IBOutlet weak var commentSwitch: UISwitch!
    
    //画面が表示された時、設定値を反映させる
    override func viewWillAppear(_ animated: Bool){
        // はじめの状態をtrueにしておく.
        commentSwitch.isOn = true
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "commentSwitchFlag") != nil{
            commentSwitch.isOn = myDefault.object(forKey: "commentSwitchFlag")as! Bool
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaultから値を取り出す
        myDefault.object(forKey: "commentSwitchFlag")
        
        //画像の表示/非表示を表す変数を用意
        var commentSwitchFlag = true
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "commentSwitchFlag") != nil{
            commentSwitchFlag = myDefault.object(forKey: "commentSwitchFlag")as! Bool
        }
        
        commentSwitch.isOn = commentSwitchFlag
        
        
    }

    
    
    @IBAction func commentSwitch(_ sender: UISwitch) {
        //UseDefaultを操作するためのオブジェクトを作成

        //スイッチの状態を保存
        //set(保存したい値、forKey:保存した値を取り出す時に指定する名前)

        myDefault.set(sender.isOn,forKey: "commentSwitchFlag")

        //即保存させる（これがないと、値が保存されていない時があります）

        myDefault.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
