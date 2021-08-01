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
    
    
    
    @IBAction func relogin(_ sender: Any) {
        //navigate to login email (sign in)
    }
    
    @IBAction func buttonsTap(_ sender: UIButton){
        //save ke array gitu(?)
    }
    
    @IBAction func faceID(_ sender: UIButton){
        //faceID function
    }
    
    @IBAction func deletePIN(_ sender: UIButton){
        //delete the last value of the array
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
