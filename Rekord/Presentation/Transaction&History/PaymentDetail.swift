//
//  PaymentDetail.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 04/08/21.
//

import UIKit

class PaymentDetail: UIViewController {
    
    @IBOutlet weak var paymentDetailCard: UIView!
    
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var transactionID: UILabel!
    @IBOutlet weak var paymentDate: UILabel!
    @IBOutlet weak var paymentAmount: UILabel!
    @IBOutlet weak var countOfPayment: UILabel!
    @IBOutlet weak var dateOfPayment: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var paymentCount: UILabel!
    @IBOutlet weak var proofOfPayment:UIImageView!
    @IBOutlet weak var paidBy: UILabel!
    @IBOutlet weak var toDocumentView: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var paymentID : String = ""
    //paymentid, paymentdate, paymentamount, paymentcount, namapartner, proofpayment
    var paymentQueue : [String] = ["","","","","","",""]
    var selectedTransaction : String = ""
    override func viewDidLoad() {
        queryForPaymentDetail()
        print("paymentQueue: ", paymentQueue, "paymentID: ", paymentID, " selectedTransasction: ", selectedTransaction)
        self.navigationItem.backButtonTitle = "Back"
        self.navigationItem.title = "Payment Details"
        proofOfPayment.image = UIImage.init(named: "receipt")
        paymentDetailCard.layer.cornerRadius = 10
        if proofOfPayment.image != nil {
            toDocumentView.isEnabled = true
        }else{
            toDocumentView.isEnabled = false
        }
        transactionID.text = paymentQueue[0]
        partnerName.text = paymentQueue[4]
        paymentDate.text = paymentQueue[1]
        paymentAmount.text = paymentQueue[2]
        paymentCount.text = paymentQueue[3]
        
    }
    func queryForPaymentDetail(){
        
        PaymentRepository.shared.getAllPayment(UserDefaults.standard.string(forKey: "userID") ?? "errorID") { [self] list, str in
           
            TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "idBusiness") ?? "errorID") { trList, str in
                for transaction in trList{
                    if transaction.idTransaction == self.selectedTransaction{
                        PartnerRepository.shared.getAllPartner { PartnerList, str in
                            for partner in PartnerList{
                                if partner.idPartner == transaction.idPartner{
                                    paymentQueue[4] = partner.name ?? "errorName"
                                }
                            }
                        }
                    }
                }
            }
            for payment in list{
                var paymentCount : Int = 0
                if payment.idTransaction == self.selectedTransaction{
                    paymentCount += 1
                    if payment.idPayment == self.paymentID{
                        paymentCount += 1
                        paymentQueue[0] = payment.idPayment ?? "errorID"
                        paymentQueue[1] = payment.createdDate ?? "errorDate"
                        paymentQueue[2] = String(payment.amount ?? 0)
                        
                        paymentQueue[3] = String(paymentCount)
                        paymentQueue[5] = payment.document ?? "No Document"
                    }
                }
                
            }
            
        }
}
}
