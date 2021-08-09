//
//  Partner.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 27/07/21.
//

import UIKit

class PartnerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var partnerListTable: UITableView!
    @IBOutlet weak var roundedUpperView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addPartnerButton: UIButton!
    
    var partnerType = ""
    var partnerName = ""
    var userId = ""
    var businessId = ""
    var partnerId = ""
    var totalTransactionsDone = 0
    var partnerCount = 0
    var transactionAmount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        searchBar.backgroundColor = UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        searchBar.barTintColor = UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        roundedUpperView.layer.cornerRadius = 30
        self.navigationController?.navigationBar.isHidden = true
        partnerListTable.register(UINib.init(nibName: "PartnerListCell", bundle: nil), forCellReuseIdentifier: "PartnerListCell")
        partnerListTable.reloadData()
        
    }
    
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        PartnerRepository.shared.getAllPartner { partnerList, partner in
            for partner in partnerList{
                if partner.idBusiness == self.businessId{
                    self.partnerType = partner.type!.rawValue
                    self.partnerName = partner.name!
                    self.partnerCount += 1
                    
                    TransactionRepository.shared.getAllTransaction(_idBusiness: self.businessId) { transactions, transaction in
                        for transaction in transactions{
                            if transaction.idPartner == self.partnerId{
                                if transaction.status == .paid{
                                    self.totalTransactionsDone += 1
                                    self.transactionAmount += transaction.totalPrice!
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = partnerListTable.dequeueReusableCell(withIdentifier: "PartnerListCell", for: indexPath)as! PartnerListCell
        cell.typeDescription.text = partnerType
        cell.partnerName.text = partnerName
        cell.numberOfTransactions.text = "\(totalTransactionsDone)"
        cell.totalTranasationValue.text = "\(transactionAmount)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        partnerCount
    }
}
