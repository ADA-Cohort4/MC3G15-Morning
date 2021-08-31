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
    var phone: String = ""
    var documentInteractionController:UIDocumentInteractionController!

    
    
    override func viewDidLoad() {
        queryForPaymentDetail()
        generateImage()
        print("paymentQueue: ", paymentQueue, "paymentID: ", paymentID, " selectedTransasction: ", selectedTransaction)
        self.navigationItem.backButtonTitle = "Back"
        self.navigationItem.title = "Payment Details"
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
        configNumber()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetailInvoice"{
            let vc = segue.destination as? DocumentView
            vc?.documentFile = paymentQueue[5]
        }
    }
    func generateImage() {
        let newImageData = Data(base64Encoded: paymentQueue[5])
        if let newImageData = newImageData {
            self.proofOfPayment.image = UIImage(data: newImageData)
        }
    }
    
    func configNumber() {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "Rp"
        formatter.currencyCode = "ID"
        let totalValueRupiah: Double = Double(paidAmount.text ?? "") ?? 0.0
        let rupiah = formatter.string(from: NSNumber(value: totalValueRupiah))
        paidAmount.text = rupiah ?? "Rp.x"
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
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let urlWhats = "https://wa.me/\(phone)/?text=Hello \(partnerName.text)!, I have performed the payment on \(paymentDate.text) for total amount \(paidAmount.text) with invoice number \(paymentID)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
          if let whatsappURL = NSURL(string: urlString) {
            if UIApplication.shared.canOpenURL(whatsappURL as URL) {
              UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
            } else {
              print("Cannot Open Whatsapp")
            }
          }
        }
        
        
    }
    
}
