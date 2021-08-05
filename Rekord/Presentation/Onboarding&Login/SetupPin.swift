//
//  ViewController.swift
//  LockScreen
//
//  Created by Ivan Valentino Sigit on 31/07/21.
//

import UIKit

class SetupPinViewController: UIViewController {
    
    
    var appleID: String?
    var businessName: String?
    var email: String?
    var phone: String?
    var address: String?

    @IBOutlet weak var PINlabel: UILabel!
    @IBOutlet var pass: [UIView]!
    @IBOutlet var numPad: [UIButton]!
    
    var code: String = ""
    var click: Int = 0
    
    @IBAction func buttonsTap(_ sender: UIButton){
        let buttonTitle = sender.title(for: .normal)!
        
        if click == 5 {
            code.append(buttonTitle)
            pass[5].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            performSegue(withIdentifier: "confirmPIN", sender: self)
        }
        
        if  code.count < 6 && (buttonTitle != ""){
            pass[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            for i in 1..<code.count+1{
                pass[i].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            click += 1
            code.append(buttonTitle)
            print("The code is \(code)")
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPIN" {
            let destinationVC = segue.destination as! ConfirmPinViewController
            destinationVC.appleID = appleID
            destinationVC.businessName = businessName
            destinationVC.email = email
            destinationVC.phone = phone
            destinationVC.address = address
            destinationVC.code = code
            
        }
    }
    
    
    @IBAction func deletePIN(_ sender: UIButton){
        code.removeLast()
        pass[code.count].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        print("The code is \(code)")
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

