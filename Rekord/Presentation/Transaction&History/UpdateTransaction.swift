//
//  UpdateTransaction.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 04/08/21.
//

import UIKit

class UpdateTransaction: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var AmountPaidCell: UIView!
    @IBOutlet weak var TermOfPaymentCell: UIView!
    @IBOutlet weak var UploadDocumentView: UIView!
    @IBOutlet weak var PaymentStatus: UITableView!
    @IBOutlet weak var uploadDocumentButton: UIButton!
    @IBOutlet weak var amountPaid: UITextField!
    @IBOutlet weak var termOfPayment: UITextField!
    @IBOutlet weak var voidTranasctionButton: UIButton!
    
    override func viewDidLoad() {
        PaymentStatus.register(UINib.init(nibName: "PaymentStatusCell", bundle: nil), forCellReuseIdentifier: "PaymentStatusCell")
        PaymentStatus.reloadData()
        
        AmountPaidCell.layer.cornerRadius = 10
        TermOfPaymentCell.layer.cornerRadius = 10
        UploadDocumentView.layer.cornerRadius = 10
        voidTranasctionButton.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PaymentStatus.dequeueReusableCell(withIdentifier: "PaymentStatusCell", for: indexPath)as! PaymentStatusCell
        return cell
    }
    
}
