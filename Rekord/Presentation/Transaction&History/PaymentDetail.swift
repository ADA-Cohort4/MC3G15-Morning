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
    
    override func viewDidLoad() {
        self.navigationItem.backButtonTitle = "Back"
        self.navigationItem.title = "Payment Details"
        proofOfPayment.image = UIImage.init(named: "receipt")
        paymentDetailCard.layer.cornerRadius = 10
        if proofOfPayment.image != nil {
            toDocumentView.isEnabled = true
        }else{
            toDocumentView.isEnabled = false
        }
    }
}
