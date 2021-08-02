//
//  ChooseTypeViewController.swift
//  Rekord
//
//  Created by Peter Lee on 01/08/21.
//

import UIKit

class ChooseTypeViewController: UIViewController {
    
    var userID: String?

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = userID
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setupBusinessBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "SetupBusinessSegue", sender: self)
    }
    
    
    
    @IBAction func joinBusinessBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "JoinBusinessSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetupBusinessSegue" {
            let destinationVC = segue.destination as! SetupBusinessViewController
            destinationVC.userID = userID
        } else if segue.identifier == "JoinBusinessSegue" {
            let destinationVC = segue.destination as! JoinBusinessViewController
            destinationVC.userID = userID
        }
    }
}
