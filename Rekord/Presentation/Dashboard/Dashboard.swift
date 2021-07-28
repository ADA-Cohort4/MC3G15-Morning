//
//  Dashboard.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

class Dashboard : UIViewController, UITableViewDataSource, UITableViewDelegate{
    static let shared = Dashboard()
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "dateCell") as! dateCell
            cell.selectedBackgroundView = UIView()
            return cell
           
        case 1:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "balanceCell") as! balanceCell
            cell.selectedBackgroundView = UIView()
            //add target to button add transaction
            cell.addTransactionBtn.addTarget(self, action: Selector("onAddBtnClick"), for: .touchUpInside)
            
            return cell
           
        default:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "transactionsCell") as! transactionsCell
            cell.partnerNameLabel.text = "poggers"
            cell.selectedBackgroundView = UIView()
            
            return cell
        
        }
    }
    @IBAction func onAddBtnClick() {
       // move to add transaction storyboard
        performSegue(withIdentifier: "toAddTransaction", sender: nil)
        
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAddTransaction", sender: nil)
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return CGFloat(180)
        case 1:
            return CGFloat(305)
        default:
            return CGFloat(270)
        }
    }
 
}
