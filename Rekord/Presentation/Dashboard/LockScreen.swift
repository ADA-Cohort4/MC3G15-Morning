//
//  LockScreen.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit
import LocalAuthentication

class LockScreen: UIViewController {
    
    @IBOutlet weak var PINlabel: UILabel!
    
    @IBOutlet var pass: [UIView]!
    @IBOutlet var numPad: [UIButton]!
    
    var code: String = ""
    var click: Int = 0
    
    @IBAction func relogin(_ sender: Any) {
        print("relogin")
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
            } else {
                click = 0
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                PINlabel.text = "Wrong pin"
                code.removeAll()
                for i in 0..<6{
                    pass[i].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }
            }
        }
    }

    
    @IBAction func faceID(_ sender: UIButton){
        print("face id")
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Please authorize with face id"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    print("successfully Login")
                    self!.performSegue(withIdentifier: "toDashboardSegue", sender: self)
                }
                
            }
        } else {
            
        }
    }
    
    @IBAction func deletePIN(_ sender: UIButton){
        if code.count != 0{
            code.removeLast()
            pass[code.count].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            click -= 1
            print("The code is \(code)")
        }
        
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
        
    }
    
}
