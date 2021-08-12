//
//  File.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

class History : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterPartnerLabel: UILabel!
    @IBOutlet weak var filterTypeLabel: UILabel!
    @IBOutlet weak var dateDrop: UIView!
    @IBOutlet weak var typeDrop: UIView!
    @IBOutlet weak var partnerDrop: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerPadding: UIView!
    
    @IBOutlet weak var filterEndLabel: UILabel!
    @IBOutlet weak var emptyHistoryLabel: UILabel!
    @IBOutlet weak var filterView: FilterView!
    
    
    private let refreshControl = UIRefreshControl()
    //nanti data hasil query masukin sini, kalo filter / search reload view dan restart query
    //URUTAN: 0 = partner name, 1 = trid, 2 = type, 3 = status, 4 = total
    var transData : [[String]] = [["Sinar Jaya", "TR#1028231", "Customer","Paid", "Rp14,000,000"], ["Epic Corp", "TR#213123", "Supplier", "Pending Payment", "Rp14,000,000"]]
    //let transData : [[String]] = []
    let customerData : [String] = ["Sinar Jaya", "Epic Corp"]
    let typeData : [String] = ["Customer", "Supplier"]
    var selectedCustomerData : String = ""
    var selectedFilter : String = ""
    var selectedEntry : String = ""
    
    
    //USE THIS FOR FILTERING QUERY
    var filterStartDate : Date = Date()
    var filterEndDate : Date = Date()

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
      
    }
    override func viewDidLoad() {
        
       
        super.viewDidLoad()
        queryForHistory()
        historyTable.dataSource = self
        historyTable.delegate = self
        configViews()
        //filterView.customerData = customerData
        //add target for filter buttons
        typeDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTypeFilterClick)))
        partnerDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onPartnerFilterClick)))
        dateDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onDateFilterClick)))
        //add target for done button in filter view
        filterView.doneBtn.addTarget(self, action: #selector(self.onFilterDoneBtnClick), for: .touchUpInside)
        //add target for refresh control
        refreshControl.addTarget(self, action: #selector(self.onRefreshPull), for: .valueChanged)
        
    }
    
    func configViews(){
        filterView.layer.cornerRadius = 10
        filterView.baseView.layer.cornerRadius = 10
        filterTypeLabel.text = "Type"
        filterPartnerLabel.text = "Partner"
        dateDrop.layer.cornerRadius = 10
        partnerDrop.layer.cornerRadius = 10
        typeDrop.layer.cornerRadius = 10
        emptyHistoryLabel.isHidden = true
        
        if transData.isEmpty{
            historyTable.isHidden = true
            emptyHistoryLabel.isHidden = false
        }
        
        headerPadding.layer.cornerRadius = 10
        
        historyTable.addSubview(refreshControl)
        searchBar.backgroundColor = UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        searchBar.barTintColor = UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.containerView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor]
        self.containerView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    override func viewDidLayoutSubviews() {
        CommonFunction.shared.addShadow(view: dateDrop)
        CommonFunction.shared.addShadow(view: partnerDrop)
        CommonFunction.shared.addShadow(view: typeDrop)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = historyTable.dequeueReusableCell(withIdentifier: "historyCell") as! historyCell
        cell.selectedBackgroundView = UIView()
        cell.partnerNameLabel.text = transData[indexPath.row][0]
        cell.transactionIDLabel.text = transData[indexPath.row][1]
        cell.typeLabel.text = transData[indexPath.row][2]
        cell.statusLabel.text = transData[indexPath.row][3]
        cell.totalPriceLabel.text = transData[indexPath.row][4]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = transData[indexPath.row][1]
        performSegue(withIdentifier: "toTransactionDetail", sender: nil)
    }
    
    @IBAction func onFilterDoneBtnClick(){
        
        if filterView.selectedOption != "" {
            selectedCustomerData = filterView.selectedOption
            switch selectedFilter{
            case "partner":
                filterPartnerLabel.text = selectedCustomerData
                break
           
            case "type":
                filterTypeLabel.text = selectedCustomerData
                break
            default:
                print("Error")
            }
        } else{
            if selectedFilter == "date"{
                filterEndLabel.text = "Date Filtered"
                filterStartDate = FilterView.dates[0]
                filterEndDate = FilterView.dates[1]
                print(filterStartDate, filterEndDate)
               }
        }
        
       
        filterView.isHidden = true
        containerView.mask = nil
        
    }
    @IBAction func onTypeFilterClick(){
        selectedFilter = "type"
        filterView.viewMode = selectedFilter
        filterView.cellData = typeData
        filterView.optionsTableView.reloadData()
        filterView.filterTitle.text = "Select Transaction Type"
        if filterView.isHidden == true{
            containerView.mask = UIView(frame: self.view.frame)
            containerView.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            filterView.isHidden = false
        }else{
            containerView.mask = nil
            filterView.isHidden = true
        
        }
    }
    @IBAction func onPartnerFilterClick(){
        selectedFilter = "partner"
        filterView.viewMode = selectedFilter
        filterView.cellData = customerData
        filterView.optionsTableView.reloadData()
        filterView.filterTitle.text = "Select Your Partner"
        if filterView.isHidden == true{
            containerView.mask = UIView(frame: self.view.frame)
            containerView.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            filterView.isHidden = false
        }else{
            containerView.mask = nil
            filterView.isHidden = true
        
        }
    }
    @IBAction func onDateFilterClick(){
        selectedFilter = "date"
        filterView.viewMode = selectedFilter
        filterView.optionsTableView.reloadData()
        filterView.filterTitle.text = "Filter History by Date"
        if filterView.isHidden == true{
            containerView.mask = UIView(frame: self.view.frame)
            containerView.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            filterView.isHidden = false
        }else{
            containerView.mask = nil
            filterView.isHidden = true
        
        }
    }
    @IBAction func onRefreshPull(){
        print("refreshed")
        
        self.refreshControl.endRefreshing()
        
    }
    
    func queryForHistory(){
        // MARK: -QUERY TRANSACTION FOR DASHBOARD
        TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) { resultList, result in
            for result in resultList{
                var partnerName = ""
                var type = ""
                PartnerRepository.shared.getAllPartner { resultPartnerList, resultString in
                    for resultPartner in resultPartnerList{
                        if resultPartner.idPartner == result.idPartner{
                            print("found partner")
                            partnerName = resultPartner.name!
                            type = resultPartner.type!.rawValue
                        }
                    }
                }
                if result.status?.rawValue == "paid"{
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currencyAccounting
                    formatter.currencySymbol = "Rp"
                    formatter.currencyCode = "ID"
                    
//                    ARLabel.text = formatter.string(from: NSNumber(value: ARValue))
                    let rupiah = formatter.string(from: NSNumber(value: result.totalPrice ?? 0))
                    let list : [String] = [partnerName, "TR#\(result.idTransaction!)", type.capitalized, (result.status!.rawValue).capitalized, rupiah!, result.dueDate!]
                
                var dashboardQueryHasSameID : Bool = false
                
                for transaction in self.transData{
                    if list[1] == transaction[1]{
                        dashboardQueryHasSameID = true
                    }
                }
                
                if dashboardQueryHasSameID == false{
                    self.transData.append(list)
                    
                }
                    
                }
            }
        }
    }
    
    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionDetails{
            let vc = segue.destination as? TransactionDetails
            vc?.inputArray[1] = selectedEntry
        }
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

