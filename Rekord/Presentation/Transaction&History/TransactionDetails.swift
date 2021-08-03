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
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Payment Details"
        CommonFunction.shared.addShadow(view: baseView)
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Payment History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentTable.dequeueReusableCell(withIdentifier: "paymentCell") as! paymentCell
        cell.paymentDateLabel.text = "4/20/69"
        cell.paymentCountLabel.text = "Payment 420"
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

