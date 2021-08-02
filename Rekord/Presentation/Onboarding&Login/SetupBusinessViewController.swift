//
//  SetupBusinessViewController.swift
//  Rekord
//
//  Created by Peter Lee on 01/08/21.
//

import UIKit

class SetupBusinessViewController: UIViewController {

    var userID: String?
    
    @IBOutlet weak var UserId: UILabel!
    
    @IBOutlet weak var businessNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setup Your Business"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
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
