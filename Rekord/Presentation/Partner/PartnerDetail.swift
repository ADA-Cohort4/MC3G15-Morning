//
//  PartnerDetail.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 31/07/21.
//

import UIKit

class PartnerDetailViewController:UIViewController{
    
    
    var partnerID: String!
 
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PartnerRepository.shared.getPartner{ resultPartner in 
            if self.partnerID == resultPartner.idPartner{
                self.partnerType.text = resultPartner.type!.rawValue
                self.contactPersonPhoneNumber.text = resultPartner.phone!
                self.companyAddress.text = resultPartner.address!
                self.contactPersonName.text = resultPartner.ownerName!
                self.emailAddress.text = resultPartner.email!
            }
        }
    }
    
}
