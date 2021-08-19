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
    //name, trid, type , status, totalvalue, totaldue, paymentcount
    var inputArray : [String] = ["", "", "", "", "", "" ,"", ""]
    var paymentArray : [[String]] = [] //0 = paymentID, 1 = paymentDate
    var selectedID : String = ""
    var onlyFinalPaymentLeft : Bool = false
    var totalDue : Double = 0
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Transaction Details"
        CommonFunction.shared.addShadow(view: baseView)
        
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        super.viewDidLoad()
        queryForDetail()
        print(paymentArray)
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
        
        
        configNumberFormats()
        
        
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
        cell.paymentDateLabel.text = paymentArray[indexPath.row][1]
        cell.paymentCountLabel.text = "Payment \(indexPath.row+1)"
        return cell
    }
    
    
    @IBAction func onUpdateBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "toUpdateTransaction", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UpdateTransaction{
            let vc = segue.destination as? UpdateTransaction
            vc?.selectedTransaction = TRIDLabel.text ?? "errorID"
            vc?.finalPayment = onlyFinalPaymentLeft
            vc?.totalDue = Double(inputArray[5]) ?? 0
            
        }
    }
    func queryForDetail(){
        TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) { resultList, result in
            for result in resultList{
                if result.idTransaction == self.inputArray[1]{
                    
                    var partnerID = ""
                    var type = ""
                    var partnerName = ""
                    
                    PartnerRepository.shared.getAllPartner { resultPartner, str in
                        for partner in resultPartner{
                            if partner.idPartner == result.idPartner{
                                partnerID = partner.idPartner!
                                type = partner.type!.rawValue
                                partnerName = partner.name ?? "No Name" //CHANGE TO PARTNER NAME
                            }
                        }
                        
                        
                    }
                    var paymentValue : Double = 0
                    PaymentRepository.shared.getAllPayment(UserDefaults.standard.string(forKey: "userID") ?? "errorID") { paymentList, String in
                        for payment in paymentList{
                            if payment.idTransaction == self.inputArray[1]{
                                print("adding payment to query....")
                                paymentValue += payment.amount ?? 0
                                
                                let list : [String] = [payment.idPayment ?? "error", payment.createdDate ?? "error"]
                                
                                self.paymentArray.append(list)
                            }
                        }
                    }
                    
                    var totalDue = result.totalPrice ?? 0
                    totalDue -= paymentValue
                  
                    //input data to list for show in UI
                    let detailList : [String] = [partnerName, result.idTransaction!, type, result.status!.rawValue,  String(result.totalPrice ?? 0), String(totalDue), String(result.paymentCount!)]
                    
                    self.inputArray = detailList
                    print("payment count: ", self.paymentArray.count, " totalPayment: ", (Int(self.inputArray[6]) ?? 0)-1 )
                    if self.paymentArray.count == (Int(self.inputArray[6]) ?? 0)-1{
                        self.onlyFinalPaymentLeft = true // check apakah dia tinggal final payment yang belom (kalo dia tinggal 1 payment doang dari payment count)
                    }
                
                    
                }
                
            }
        }
    }
    func configNumberFormats(){
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "Rp"
        formatter.currencyCode = "ID"
        print(inputArray[4])
        totalValueLabel.text = formatter.string(from: NSNumber(value: Double(inputArray[4]) ?? 0))
        totalDueLabel.text = formatter.string(from: NSNumber(value: Double(inputArray[5]) ?? 0))
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

