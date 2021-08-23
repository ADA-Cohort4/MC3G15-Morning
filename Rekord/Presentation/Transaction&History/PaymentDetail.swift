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
    //paymentid, paymentdate, paymentamount, paymentcount, namapartner, proofpayment, userUpload
    var paymentQueue : [String] = ["","","","","","","",""]
    var selectedTransaction : String = ""
    var trPaymentCount : String = ""
    
    
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
        dateOfPayment.text = paymentQueue[1]
        paidAmount.text = paymentQueue[2]
        paymentCount.text = paymentQueue[3]
        paidBy.text = "Uploaded by \(paymentQueue[6])"
        
    }
    func queryForPaymentDetail(){
        
        PaymentRepository.shared.getAllPayment(UserDefaults.standard.string(forKey: "userID") ?? "errorID") { [self] list, str in
            var paymentCount : Int = 0
            for payment in list{
                
                if payment.idTransaction == self.selectedTransaction{
                    paymentCount += 1
                    if payment.idPayment == self.paymentID{
                        BusinessRepository.shared.getAllBusiness(UserDefaults.standard.string(forKey: "userID") ?? "errorID") { businessList, str in
                            for business in businessList{
                                if business.idBusiness == UserDefaults.standard.string(forKey: "businessID") ?? "errorID"{
                                    paymentQueue[6] = business.name ?? "errorName"
                                }
                                
                            }
                        }
                        
                        paymentQueue[0] = payment.idPayment ?? "errorID"
                        paymentQueue[1] = payment.createdDate ?? "errorDate"
                        paymentQueue[2] = String(payment.amount ?? 0)
                        
                        paymentQueue[3] = String(paymentCount)
                        paymentQueue[5] = payment.document ?? "No Document"
                        
                    }
                }
                
                
            }
            paymentQueue[3] += " of \(trPaymentCount)"
            
        }
    }
    
}
