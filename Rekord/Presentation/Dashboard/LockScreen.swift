//
//  LockScreen.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit

class LockScreen: UIViewController {
    
    @IBOutlet weak var PINlabel: UILabel!
    
    @IBOutlet var pass: [UIView]!
    @IBOutlet var numPad: [UIButton]!
    
    var code: String = ""
    var click: Int = 0
    
    @IBAction func relogin(_ sender: Any) {
        //navigate to login email (sign in)
    }
    
    @IBAction func buttonsTap(_ sender: UIButton){
        let buttonTitle = sender.title(for: .normal)!
        if  code.count < 6 && (buttonTitle != ""){
            pass[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            for i in 1..<code.count+1{
                pass[i].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            code.append(buttonTitle)
            click += 1
            print("The code is \(code)")
        }
        if click == 6{
            let defaults = UserDefaults.standard
            let userCode = defaults.value(forKey: "passcode") as? String
            if code == userCode {
                performSegue(withIdentifier: "toDashboardSegue", sender: self)
                print(userCode)
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                PINlabel.text = "Wrong pin"
                code.removeAll()
                for i in 0..<6{
                    pass[i].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }
            }
            //navigate to dashboard if true, try again if false
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDashboardSegue" {
//            let destinationVC = segue.destination as! Dashboard
//        }
//    }
    
    @IBAction func faceID(_ sender: UIButton){
        //faceID function
    }
    
    @IBAction func deletePIN(_ sender: UIButton){
        code.removeLast()
        pass[code.count].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        click -= 1
        print("The code is \(code)")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        for i in 0..<6{
            pass[i].layer.cornerRadius = 10
            pass[i].layer.borderWidth = 3
            pass[i].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        for j in 0..<10{
            numPad[j].layer.cornerRadius = 37.5
        }
        // num[10] face id, num[11] delete
        
    }
    
}
