//
//  SetupBusinessViewController.swift
//  Rekord
//
//  Created by Peter Lee on 01/08/21.
//

import UIKit

class SetupBusinessViewController: UIViewController {

    var userID: String?
    
    
    @IBOutlet weak var businessNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextView!
    
    @IBOutlet weak var businessNameView: UIView!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var phoneView: UIView!
        
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setup Your Business"
        businessNameView.layer.cornerRadius = 10
        emailView.layer.cornerRadius = 10
        addressView.layer.cornerRadius = 10
        phoneView.layer.cornerRadius = 10
        
        addressField.layer.borderWidth = 1.0
        addressField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        addressField.layer.cornerRadius = 10
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(validateBusiness))
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    
    

    
    
    @objc func validateBusiness(){
        if businessNameField.text == "" {
            businessNameField.placeholder = "Please fill in business name"
            businessNameField.backgroundColor = #colorLiteral(red: 1, green: 0.8408887982, blue: 0.833807826, alpha: 1)
        }

        if emailField.text == "" {
            emailField.placeholder = "Please fill in email"
            emailField.backgroundColor = #colorLiteral(red: 1, green: 0.8408887982, blue: 0.833807826, alpha: 1)
        }

        if phoneField.text == "" {
            phoneField.placeholder = "Please fill in phone"
            phoneField.backgroundColor = #colorLiteral(red: 1, green: 0.8408887982, blue: 0.833807826, alpha: 1)
        }
        if addressField.text == "" {
//            addressField. = "Please fill in address"
            addressField.backgroundColor = #colorLiteral(red: 1, green: 0.8408887982, blue: 0.833807826, alpha: 1)
        }

        if businessNameField.text != "" && emailField.text != "" && phoneField.text != "" && addressField.text != "" {
            performSegue(withIdentifier: "ToSetupPinSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToSetupPinSegue"{
            let destinationVC = segue.destination as! SetupPinViewController
            destinationVC.appleID = userID
            destinationVC.businessName = businessNameField.text
            destinationVC.email = emailField.text
            destinationVC.phone = phoneField.text
            destinationVC.address = addressField.text
            
        }
    }
    
    @IBAction func skipThisButton(_ sender: Any) {
        print("skip")
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
