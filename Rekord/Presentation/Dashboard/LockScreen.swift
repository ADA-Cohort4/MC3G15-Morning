//
//  LockScreen.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit

class LockScreen: UIViewController {
    
    @IBOutlet weak var PINlabel: UILabel!
    
    @IBOutlet weak var pass1: UIView!
    @IBOutlet weak var pass2: UIView!
    @IBOutlet weak var pass3: UIView!
    @IBOutlet weak var pass4: UIView!
    @IBOutlet weak var pass5: UIView!
    @IBOutlet weak var pass6: UIView!
    
    @IBOutlet weak var num0: UIButton!
    @IBOutlet weak var num1: UIButton!
    @IBOutlet weak var num2: UIButton!
    @IBOutlet weak var num3: UIButton!
    @IBOutlet weak var num4: UIButton!
    @IBOutlet weak var num5: UIButton!
    @IBOutlet weak var num6: UIButton!
    @IBOutlet weak var num7: UIButton!
    @IBOutlet weak var num8: UIButton!
    @IBOutlet weak var num9: UIButton!
    
    @IBOutlet weak var faceid: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    
    @IBAction func forgotPIN(_ sender: Any) {
        
    }
    
    @IBAction func relogin(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        pass1.layer.cornerRadius = 10
        pass2.layer.cornerRadius = 10
        pass3.layer.cornerRadius = 10
        pass4.layer.cornerRadius = 10
        pass5.layer.cornerRadius = 10
        pass6.layer.cornerRadius = 10
        
        num0.layer.cornerRadius = 37.5
        num1.layer.cornerRadius = 37.5
        num2.layer.cornerRadius = 37.5
        num3.layer.cornerRadius = 37.5
        num4.layer.cornerRadius = 37.5
        num5.layer.cornerRadius = 37.5
        num6.layer.cornerRadius = 37.5
        num7.layer.cornerRadius = 37.5
        num8.layer.cornerRadius = 37.5
        num9.layer.cornerRadius = 37.5
        
    }
    
}
