//
//  ViewController.swift
//  LockScreen
//
//  Created by Ivan Valentino Sigit on 31/07/21.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var PINlabel: UILabel!
    @IBOutlet weak var PINlabel2: UILabel!
    @IBOutlet var pass: [UIView]!
    @IBOutlet var numPad: [UIButton]!
    @IBOutlet var pass2: [UIView]!
    @IBOutlet var numPad2: [UIButton]!
    
    var code: String = ""
    var confirm: String = ""
    
    @IBAction func buttonsTap(_ sender: UIButton){
        let buttonTitle = sender.title(for: .normal)!
        if  code.count < 6 && (buttonTitle != ""){
            pass[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            for i in 1..<code.count+1{
                pass[i].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            code.append(buttonTitle)
            print("The code is \(code)")
        } else if code.count == 6{
            //navigate to Confirm PIN if true, try again if false
            performSegue(withIdentifier: "confirmPIN", sender: nil)
            
        }
        
    }
    
    @IBAction func buttonsTap2(_ sender: UIButton){
        let buttonTitle = sender.title(for: .normal)!
        if  confirm.count < 6 && (buttonTitle != ""){
            pass2[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            for i in 1..<confirm.count+1{
                pass2[i].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            confirm.append(buttonTitle)
            print("The code is \(confirm)")
        }
        
        if confirm.count == 6{
            //navigate to Confirm PIN if true, try again if false
            if code == confirm{
                //navigate ke Page berikutnya
                print("masuk")
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                print("wrong password")
                confirm.removeAll()
                for i in 0..<6{
                    pass2[i].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }
                navigationController?.popToRootViewController(animated: true)
            }
            print("full")
        }
        
    }
    
    @IBAction func deletePIN(_ sender: UIButton){
        code.removeLast()
        pass[code.count].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        print("The code is \(code)")
    }
    
    @IBAction func deleteCfmPIN(_ sender: UIButton){
        confirm.removeLast()
        pass2[confirm.count].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        print("The code is \(confirm)")
    }
    
//    func
    
    //MARK: UI View
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

