//
//  JoinBusinessViewController.swift
//  Rekord
//
//  Created by Peter Lee on 01/08/21.
//

import UIKit

class JoinBusinessViewController: UIViewController {

    var userID: String?
    
    
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var businessEmailField: UITextField!
    @IBOutlet weak var cidField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Join A Business"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinBusinessButton(_ sender: Any) {
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
