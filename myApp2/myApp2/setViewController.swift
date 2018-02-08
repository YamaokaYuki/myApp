

import UIKit

class setViewController: UIViewController {
    
    @IBOutlet weak var functionAlertSwitch: UISwitch!
    @IBOutlet weak var commentSwitch: UISwitch!
    
    let myDefault = UserDefaults.standard
    
    //画面が表示された時、設定値を反映させる
    override func viewWillAppear(_ animated: Bool){
        // はじめの状態をtrueにしておく.
        functionAlertSwitch.isOn = false
        commentSwitch.isOn = false
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "functionSwitchFlag") != nil{
            functionAlertSwitch.isOn = myDefault.object(forKey: "functionSwitchFlag") as! Bool
        }
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "commentSwitchFlag") != nil{
            commentSwitch.isOn = myDefault.object(forKey: "commentSwitchFlag")as! Bool
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //画像の表示・非表示を表す変数を用意
        
        //UserDefaultから値を取り出す
        
//        var myDefault = UserDefaults.standard
        myDefault.object(forKey: "functionSwitchFlag")
        myDefault.object(forKey: "commentSwitchFlag")
        
        //画像の表示/非表示を表す変数を用意
        var functionSwitchFlag = true
        var commentSwitchFlag = true

        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "functionSwitchFlag") != nil{
            functionSwitchFlag = myDefault.object(forKey: "functionSwitchFlag")as! Bool
        }
        
        //保存されてる値が存在した時
        if myDefault.object(forKey: "commentSwitchFlag") != nil{
            commentSwitchFlag = myDefault.object(forKey: "commentSwitchFlag")as! Bool
        }
        
        functionAlertSwitch.isOn = functionSwitchFlag
        commentSwitch.isOn = commentSwitchFlag
        
        
    }
    
    
    @IBAction func functionAlertSwitch(_ sender: UISwitch) {
        
        //UseDefaultを操作するためのオブジェクトを作成
        
//        var myDefault = UserDefaults.standard
        
        //スイッチの状態を保存
        //set(保存したい値、forKey:保存した値を取り出す時に指定する名前)
        
        myDefault.set(sender.isOn,forKey: "functionSwitchFlag")
        
        //即保存させる（これがないと、値が保存されていない時があります）
        
        myDefault.synchronize()
    }
    
    
    @IBAction func commentSwitch(_ sender: UISwitch) {
        //UseDefaultを操作するためのオブジェクトを作成

//        var myDefault = UserDefaults.standard

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
