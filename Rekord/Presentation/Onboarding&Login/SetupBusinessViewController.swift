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
    @IBOutlet weak var addressField: UITextField!
    
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "ToSetupPinSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let destinationNavigationController = segue.destination as! UINavigationController
//        let targetController = destinationNavigationController.topViewController
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
