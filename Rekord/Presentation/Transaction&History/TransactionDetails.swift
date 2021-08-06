//
//  TransactionDetails.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 02/08/21.
//

import UIKit

class TransactionDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var TRIDLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalDueLabel: UILabel!
    
    @IBOutlet weak var paymentCountLabel: UILabel!
    
    @IBOutlet weak var updatePaymentBtn: UIButton!
    @IBOutlet weak var viewInvoiceBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var paymentTable: UITableView!
    
    var inputArray : [String] = ["Sinar Jaya", "TR#10928329103", "Supplier", "Incomplete", "Rp24.000.000", "Rp11.000.000", "2 of 4"]
    var paymentArray : [String] = ["14/6/21", "23/7/21"]
    var selectedID : String = ""
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Transaction Details"
        CommonFunction.shared.addShadow(view: baseView)
        
        
       /* TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.value(forKey: "businessID") as! String) { resultList, result in
             for result in resultList{
                if result.airtableId == self.selectedID{
                    
                 var partnerID = ""
                 var type = ""
                    
                 PartnerRepository.shared.getPartner { resultPartner in
                     if resultPartner.idPartner == result.idPartner{
                         partnerID = resultPartner.idPartner!
                         type = resultPartner.type!.rawValue//CHANGE TO PARTNER NAME
                     }
                     
                 }
                    let list : [String] = [partnerID, result.idTransaction!, type, result.status!.rawValue,  String(result.totalPrice ?? 0), "Rp11.000.000", String(result.paymentCount!)]
                 self.inputArray = list
                }
                
             }
         }*/
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
        super.viewDidLoad()
        
        configViews()
        paymentTable.delegate = self
        paymentTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    func configViews(){
        baseView.layer.cornerRadius = 10
        
        updatePaymentBtn.layer.cornerRadius = 10
        viewInvoiceBtn.layer.cornerRadius = 10
        
        viewInvoiceBtn.layer.borderWidth = 2
        viewInvoiceBtn.layer.borderColor = UIColor.link.cgColor
        
        partnerNameLabel.text = inputArray[0]
        TRIDLabel.text = inputArray[1]
        typeLabel.text = inputArray[2]
        statusLabel.text = inputArray[3]
        totalValueLabel.text = inputArray[4]
        totalDueLabel.text = inputArray[5]
        paymentCountLabel.text = inputArray[6]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Payment History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentTable.dequeueReusableCell(withIdentifier: "paymentCell") as! paymentCell
        cell.paymentDateLabel.text = paymentArray[indexPath.row]
        cell.paymentCountLabel.text = "Payment \(indexPath.row+1)"
        return cell
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

