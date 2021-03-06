//
//  Partner.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 27/07/21.
//

import UIKit

class PartnerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
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
    var filteredPartner: [[String]] = []
    var selectedPartnerID : String = ""
    var lastTransactionDate: String = ""
    var individualPartner: [String] = []
    
    private let refreshControl = UIRefreshControl()
    
    
    
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
        emptyButton.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = true
        partnerListTable.register(UINib.init(nibName: "PartnerListCell", bundle: nil), forCellReuseIdentifier: "PartnerListCell")
        
        refreshControl.addTarget(self, action: #selector(self.onRefreshPull), for: .valueChanged)
        partnerListTable.addSubview(refreshControl)
        partnerListTable.reloadData()
        
        searchBar.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        partnerListTable.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        partnerArray = []
        queryPartners()
        if partnerArray.count == 1{ //check apakah transaksi baru dibuat dari empty state
            self.partnerListTable.isHidden = false
            self.emptyImage.isHidden = true
            self.emptyLabel.isHidden = true
            self.emptyButton.isHidden = true
        }
        self.partnerListTable.reloadData()
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
        let cell = partnerListTable.dequeueReusableCell(withIdentifier: "PartnerListCell", for: indexPath) as! PartnerListCell
            //mulai dari paling baru dibuat
        cell.partnerName.text = partnerArray[indexPath.section][1]
       // cell.typeDescription.text = partnerArray[count-indexPath.section-1][5]
        cell.lastTransactionDate.text = partnerArray[indexPath.section][4]
        lastTransactionDate = partnerArray[indexPath.section][4]
        cell.numberOfTransactions.text = partnerArray[indexPath.section][2]
        cell.totalTranasationValue.text = partnerArray[indexPath.section][3]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPartnerID = partnerArray[indexPath.section][0]
        transactionAmount = Double(partnerArray[indexPath.section][3]) ?? 0.0
        totalTransactionsDone = Int(partnerArray[indexPath.section][2]) ?? 0
        lastTransactionDate = partnerArray[indexPath.section][4]
        individualPartner = partnerArray[indexPath.section]
//        print(partnerArray)
        partnerName = partnerArray[indexPath.section][1]
        performSegue(withIdentifier: "toPartnerDetail", sender: self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        partnerArray.count
    }
    
    
    
    func queryPartners(){
        
        PartnerRepository.shared.getAllPartner { list, str in
            for partner in list{
              
                if partner.idBusiness == UserDefaults.standard.string(forKey: "businessID") && partner.status == .active{ //check untuk active partner sadja
                    
                    var transactionCount: Int = 0
                    var transactionValue: Double = 0
                    var transactionDate: String = ""
                
                    
                    TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) {transactionArr, str in
                        for transaction in transactionArr {
                            print("transaction count", transactionArr.count)
                            if transaction.idPartner == partner.idPartner{
                                transactionCount += 1
                                transactionValue += transaction.totalPrice ?? 0
                                transactionDate = transaction.updatedDate ?? "1990-03-03"
                                
                            }
                        }
                        self.totalTransactionsDone = transactionCount
                        let formatter = NumberFormatter()
                        formatter.locale = Locale.current
                        formatter.numberStyle = .currencyAccounting
                        formatter.currencySymbol = "Rp"
                        formatter.currencyCode = "ID"
                        
    //                    ARLabel.text = formatter.string(from: NSNumber(value: ARValue))
                        let rupiah = formatter.string(from: NSNumber(value: transactionValue))
                        if transactionCount == 0{
                        let list : [String] = [partner.idPartner ?? "00", partner.name ?? "nullPartner", "0", "Rp 0", "None" // partner.type?.rawValue ?? "error"
                        ]
                            self.partnerArray.insert(list, at: 0)
                            
                        } else{
                            
                            let list : [String] = [partner.idPartner ?? "00", partner.name ?? "nullPartner", String(transactionCount), String(rupiah ?? "Rp. 0"), transactionDate  //partner.type?.rawValue ?? "error"
                            ]
//                            self.partnerArray.append(list)
                            self.partnerArray.insert(list, at: 0)
                        }
                        
                        self.transactionAmount = transactionValue
                        
                    }
                    
                }
                
            }
        }
     

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPartnerDetail"{
//            let navController = segue.destination as! UINavigationController
//            let destinationVC = navController.topViewController as! PartnerDetailViewController
            let vc = segue.destination as! PartnerDetailViewController
            vc.partnerID = selectedPartnerID
            vc.transactionAmount = transactionAmount
            vc.totalTransactionsDone = totalTransactionsDone
            vc.transactionDate = lastTransactionDate
            vc.partnerArray = individualPartner
            vc.name = partnerName
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPartner = []
        if searchText == ""{
            partnerArray = []
            queryPartners()
        }else{
            var num = 0
            for partner in partnerArray{
                if partnerArray[num][1].lowercased().contains(searchText.lowercased()){
                        filteredPartner.append(partner)
                    }
                num += 1
            }
            partnerArray = []
            partnerArray = filteredPartner
            self.partnerListTable.reloadData()
        }
        self.partnerListTable.reloadData()
    }
}

extension PartnerListViewController{
    @IBAction func unwindToPartnerList( segue: UIStoryboardSegue){
      print("undwound")
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
    @IBAction func onRefreshPull(){
        partnerArray = []
        queryPartners()
        partnerListTable.reloadData()
        self.refreshControl.endRefreshing()
    }
}
