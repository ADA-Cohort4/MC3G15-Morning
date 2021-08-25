//
//  PartnerDetail.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 31/07/21.
//

import UIKit

class PartnerDetailViewController:UIViewController{
    
    
    var partnerID: String = ""
    var totalTransactionsDone: Int = 0
    var transactionAmount: Double = 0.0
    var transactionDate: String = ""
    var partnerArray: [String]?
    var name: String = ""
 
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var partnerDetailView: UIView!
    @IBOutlet weak var editPartnerButton: UIButton!
    @IBOutlet weak var viewTranasctionsButton: UIButton!
    
    //Static Labels
    //General Info
    @IBOutlet weak var contactPersonLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var cpPhoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //Transaction Summary
    @IBOutlet weak var partnerTypeLabel: UILabel!
    @IBOutlet weak var lastTransactionLabel: UILabel!
    @IBOutlet weak var totalTransactionLabel: UILabel!
    @IBOutlet weak var totalTransactionsDoneLabel: UILabel!
    
    //Label to Change according to Partners
    @IBOutlet weak var partnerName: UILabel!
    //General Info
    @IBOutlet weak var contactPersonName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var contactPersonPhoneNumber: UILabel!
    @IBOutlet weak var companyAddress: UILabel!
    //TransactionSummary
    @IBOutlet weak var partnerType: UILabel!
    @IBOutlet weak var lastTransactionDate: UILabel!
    @IBOutlet weak var totalTransactionValue: UILabel!
    @IBOutlet weak var totalTransactions: UILabel!
    
    
    override func viewDidLoad() {
       
        partnerDetailView.layer.cornerRadius = 10
        detailView.layer.cornerRadius = 10
        editPartnerButton.layer.cornerRadius = 10
        viewTranasctionsButton.layer.cornerRadius = 10
        partnerName.text = name
        partnerName.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        PartnerRepository.shared.getAllPartner{ resultPartner,err  in
            for partner in resultPartner{
                if self.partnerID == partner.idPartner{
                    self.contactPersonPhoneNumber.text = partner.phone!
                    self.companyAddress.text = partner.address!
                    self.contactPersonName.text = partner.ownerName!
                    self.emailAddress.text = partner.email!
                    self.totalTransactionValue.text = String(self.transactionAmount)
                    self.totalTransactions.text = String(self.totalTransactionsDone)
                    self.lastTransactionDate.text = self.transactionDate
                }
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditPartnerViewController{
            let vc = segue.destination as? EditPartnerViewController
            vc?.partnerId = self.partnerID
            
        }
    }
    
}
