//
//  ConfirmPinViewController.swift
//  Rekord
//
//  Created by Peter Lee on 05/08/21.
//

import UIKit

class ConfirmPinViewController: UIViewController {

    
    var confirm: String = ""
    
    var appleID: String?
    var businessName: String?
    var email: String?
    var phone: String?
    var address: String?
    var code: String!
    let userDefaults = UserDefaults()

    
    @IBOutlet var pass2: [UIView]!
    @IBOutlet var numPad2: [UIButton]!
    @IBOutlet weak var PINlabel2: UILabel!

    override func viewDidLoad(){
        super.viewDidLoad()
        
        for i in 0..<6{
            pass2[i].layer.cornerRadius = 10
            pass2[i].layer.borderWidth = 3
            pass2[i].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        for j in 0..<10{
            numPad2[j].layer.cornerRadius = 37.5
        }
        // num[10] face id, num[11] delete
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
                let userID = UUID().uuidString
                let newUser = UserModel(idUser: userID, appleId: appleID!, passcode: confirm, role: .owner, email: email!, profileUrl: "", phone: phone!, airtableId: "", status: "")
                UserRepository.shared.saveUser(user: newUser) { (result) in
                    if result.airtableId != "" || result.airtableId != nil {
                        DispatchQueue.main.async {
                            
                        
                        self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        print("error save")
                    }
                }
                userDefaults.setValue(newUser.appleId, forKey: "appleID")
                userDefaults.setValue(newUser.idUser, forKey: "userID")
                userDefaults.setValue(newUser.passcode, forKey: "passcode")
                userDefaults.setValue(newUser.role?.rawValue, forKey: "role")
                userDefaults.setValue(newUser.email, forKey: "email")
                userDefaults.setValue(newUser.profileUrl, forKey: "profileUrl")
                userDefaults.setValue(newUser.phone, forKey: "phone")
                userDefaults.setValue(newUser.airtableId, forKey: "airtableId")
                userDefaults.setValue(newUser.status, forKey: "status")
                performSegue(withIdentifier: "confirmPINSegue", sender: self)
                print("success")
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                PINlabel2.text = "Wrong PIN"
                print("wrong password")
                confirm.removeAll()
                for i in 0..<6{
                    pass2[i].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }
            }
            print("full")
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPINSegue" {
            let destinationVC = segue.destination as! Dashboard
        }
    }
    
    @IBAction func deleteCfmPIN(_ sender: UIButton){
        confirm.removeLast()
        pass2[confirm.count].layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        print("The code is \(confirm)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
