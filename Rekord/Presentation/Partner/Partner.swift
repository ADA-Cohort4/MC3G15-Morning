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
    @IBOutlet weak var emptyImage: UIImageView!
    
    @IBOutlet weak var emptyButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    var partnerType = ""
    var partnerName = ""
    var userId = ""
    var businessId = ""
    var partnerId = ""
    var totalTransactionsDone = 0
    var partnerCount = 1
    var transactionAmount: Double = 0.0
    var partnerArray : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryPartners()
        print(partnerArray)
        if partnerArray.count == 0 {
            partnerListTable.isHidden = true
            emptyImage.isHidden = false
            emptyButton.isHidden = false
            emptyLabel.isHidden = false
        } else {
            partnerListTable.isHidden = false
            emptyImage.isHidden = true
            emptyButton.isHidden = true
            emptyLabel.isHidden = true
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        searchBar.backgroundColor = UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        searchBar.barTintColor = UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        partnerListTable.dataSource = self
        partnerListTable.delegate = self
        roundedUpperView.layer.cornerRadius = 30
        self.navigationController?.navigationBar.isHidden = true
        partnerListTable.register(UINib.init(nibName: "PartnerListCell", bundle: nil), forCellReuseIdentifier: "PartnerListCell")
        
        partnerListTable.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    @IBAction func emptyButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toAddPartnerSegue", sender: self)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = partnerListTable.dequeueReusableCell(withIdentifier: "PartnerListCell", for: indexPath)as! PartnerListCell
        cell.typeDescription.text = partnerArray[indexPath.row][5]
        cell.lastTransactionDate.text = partnerArray[indexPath.row][4]
        cell.partnerName.text = partnerArray[indexPath.row][1]
        cell.numberOfTransactions.text = partnerArray[indexPath.row][2]
        cell.totalTranasationValue.text = partnerArray[indexPath.row][3]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        partnerArray.count
    }
    func queryPartners(){
        
        PartnerRepository.shared.getAllPartner { list, str in
            for partner in list{
                if partner.idBusiness == UserDefaults.standard.string(forKey: "businessID"){
                    var transactionCount: Int = 0
                    var transactionValue: Double = 0
                    var transactionDate: String = ""
                
                    
                    TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) {transactionArr, str in
                        for transaction in transactionArr {
                            if transaction.idPartner == partner.idPartner && transactionArr.count != 0 {
                                transactionCount += 1
                                transactionValue += transaction.totalPrice ?? 0
                                transactionDate = transaction.updatedDate ?? "1990-03-03"
                                
                            }else if transactionArr.count == 0 {
                                transactionCount = 0
                                transactionValue = 0
                                transactionDate = "1990-03-03"
                            }
                        }
                        let formatter = NumberFormatter()
                        formatter.locale = Locale.current
                        formatter.numberStyle = .currencyAccounting
                        formatter.currencySymbol = "Rp"
                        formatter.currencyCode = "ID"
                        
    //                    ARLabel.text = formatter.string(from: NSNumber(value: ARValue))
                        let rupiah = formatter.string(from: NSNumber(value: transactionValue))
                        let list : [String] = [partner.idPartner ?? "00", partner.name ?? "nullPartner", String(transactionCount) ?? "0", String(rupiah ?? "Rp. 0"), transactionDate ?? "1990-03-03", partner.type?.rawValue ?? "error"]
                        self.partnerArray.append(list)
                    }
                    
                }
                
            }
        }
     

    }
}

extension PartnerListViewController{
    @IBAction func unwindToPartnerList( segue: UIStoryboardSegue){
        queryPartners()
        print(partnerArray.count)
        if partnerArray.count == 0 {
            partnerListTable.isHidden = true
            emptyImage.isHidden = false
            emptyButton.isHidden = false
            emptyLabel.isHidden = false
        } else {
            partnerListTable.isHidden = false
            emptyImage.isHidden = true
            emptyButton.isHidden = true
            emptyLabel.isHidden = true
        }
        partnerListTable.reloadData()
        
    }
}
