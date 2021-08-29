//
//  File.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

class History : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
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
    
    @IBOutlet weak var resetFIlterBtn: UIButton!
    
    
    private let refreshControl = UIRefreshControl()
    //nanti data hasil query masukin sini, kalo filter / search reload view dan restart query
    //URUTAN: 0 = partner name, 1 = trid, 2 = type, 3 = status, 4 = total
    var transData : [[String]] = []
    var filteredTrans : [[String]] = []
    let customerData : [String] = []
//    let typeData : [String] = ["Customer", "Supplier"]
    var partnerData : [[String]] = [] // for filter list and filter query, id, name
    let typeData : [String] = ["Incoming", "Outgoing"]

    var selectedCustomerData : String = ""
    var selectedCustomerIndex : Int = 0
    var selectedType : String = ""
    var selectedFilter : String = ""
    var selectedEntry : String = ""
    
    
    //USE THIS FOR FILTERING QUERY
    var filterStartDate : Date = Date()
    var filterEndDate : Date = Date()

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
      
    }
    override func viewDidAppear(_ animated: Bool) {
        transData = []
        queryForHistory(isFilter: false, filterType: "none")
        self.historyTable.reloadData()
        configViews()
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        queryForHistory(isFilter: false, filterType: "epic")
        historyTable.dataSource = self
        historyTable.delegate = self
        configViews()
        //add target for filter buttons
        typeDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTypeFilterClick)))
        partnerDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onPartnerFilterClick)))
        dateDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onDateFilterClick)))
        //add target for done button in filter view
        filterView.doneBtn.addTarget(self, action: #selector(self.onFilterDoneBtnClick), for: .touchUpInside)
        //add target for refresh control
        refreshControl.addTarget(self, action: #selector(self.onRefreshPull), for: .valueChanged)
        
        searchBar.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        filterTypeLabel.text = "Type"
        filterPartnerLabel.text = "Partner"

    }
    
    func configViews(){
        filterView.layer.cornerRadius = 10
        filterView.baseView.layer.cornerRadius = 10

        dateDrop.layer.cornerRadius = 10
        partnerDrop.layer.cornerRadius = 10
        typeDrop.layer.cornerRadius = 10
        emptyHistoryLabel.isHidden = true
        historyTable.isHidden = false
        
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
        cell.transactionIDLabel.text = "TR#\(transData[indexPath.row][1])"
        cell.typeLabel.text = transData[indexPath.row][2]
        cell.statusLabel.text = transData[indexPath.row][3]
        cell.totalPriceLabel.text = transData[indexPath.row][4]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = transData[indexPath.row][1]
        performSegue(withIdentifier: "toTransactionDetail", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       filteredTrans = []
        if searchText == "" {
            transData = []
            queryForHistory(isFilter: false, filterType: "epic")
            print(transData[0])
        }else{
            var count = 0
            for transaction in transData{
                if transData[count][1].lowercased().contains(searchText.lowercased()) {
                    filteredTrans.append(transaction)
                }
                count += 1
            }
            transData = []
            transData = filteredTrans
            self.historyTable.reloadData()
        }
        self.historyTable.reloadData()
    }
    
    @IBAction func onFilterDoneBtnClick(){
        
        if filterView.selectedOption != "" {
            selectedCustomerData = filterView.selectedOption
            selectedCustomerIndex = filterView.selectedIndex
            switch selectedFilter{
            case "partner":
                filterPartnerLabel.text = selectedCustomerData
                self.queryForHistory(isFilter: true, filterType: selectedFilter)
                print("transData1 ", transData)
                self.historyTable.reloadData()
                filterView.selectedOption = ""
                break
           
            case "type":
                selectedType = filterView.selectedOption
                filterTypeLabel.text = selectedType
                queryForHistory(isFilter: true, filterType: selectedFilter)
                self.historyTable.reloadData()
                filterView.selectedOption = ""
                break
            default:
                print("Error")
            }
        } else{
            if selectedFilter == "date"{
                filterEndLabel.text = "Date Filtered"
                filterStartDate = FilterView.dates[0]
                filterEndDate = FilterView.dates[1]
                queryForHistory(isFilter: true, filterType: selectedFilter)
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
        partnerData = []
        partnerFilterQuery()
        filterView.viewMode = selectedFilter
        var filterData : [String] = []
        for i in partnerData{
            filterData.append(i[1])
        }
        filterView.cellData = filterData
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
    
    @IBAction func onResetFIlterBtnClick(_ sender: Any) {
        filterView.selectedOption = ""
        self.filterEndDate = Date()
        self.filterStartDate = Date()
        self.selectedType = ""
        self.selectedFilter = ""
        self.selectedEntry = ""
        self.selectedCustomerData = ""
        self.selectedCustomerIndex = 0
        filterPartnerLabel.text = "Partner"
        filterTypeLabel.text = "Type"
        filterEndLabel.text = "Date"
        
        queryForHistory(isFilter: false, filterType: "none")
        print(transData)
        self.historyTable.reloadData()
        configViews()
        
    }
    
    @IBAction func onRefreshPull(){
        print("refreshed")
        
        self.refreshControl.endRefreshing()
        
    }
    
    func queryForHistory(isFilter : Bool, filterType : String){
        transData = []
        // MARK: -QUERY TRANSACTION FOR DASHBOARD
        TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) { resultList, result in
            for result in resultList{
                var partnerName = ""
                let type = result.type?.rawValue ?? "errorType"
               
                if result.status?.rawValue == "paid"{
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currencyAccounting
                    formatter.currencySymbol = "Rp"
                    formatter.currencyCode = "ID"
                    
                    PartnerRepository.shared.getAllPartner { resultPartnerList, resultString in
                        for resultPartner in resultPartnerList{
                            if resultPartner.idPartner == result.idPartner{
                                print("found partner")
                                partnerName = resultPartner.name!
                            }
                        }
                    }
                    let rupiah = formatter.string(from: NSNumber(value: result.totalPrice ?? 0))
                    let list : [String] = [partnerName, "\(result.idTransaction!)", type.capitalized, (result.status!.rawValue).capitalized, rupiah!, result.dueDate!]
                
                var dashboardQueryHasSameID : Bool = false
                
                for transaction in self.transData{
                    if list[1] == transaction[1]{
                        dashboardQueryHasSameID = true
                    }
                }
                
                if dashboardQueryHasSameID == false{
                    print(self.selectedType, " ", list[2])
                    if isFilter == true{
                        switch filterType{
                        case "partner":
                            if list[0] == self.selectedCustomerData{
                                self.transData.append(list)
                            }
                            break
                        case "type":
                            if list[2] == self.selectedType{
                                self.transData.append(list)
                            }
                            break
                        case "date":
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            let date = formatter.date(from: result.updatedDate ?? "1990-02-02")
                            print("Date: ", date, "StartDate: ", self.filterStartDate, "endDate: ", self.filterEndDate)
                            //check if transaction date is within filter
                            if date?.isWithinFilterDate(date: self.filterStartDate, andDate: self.filterEndDate) == true{
                                self.transData.append(list)
                            }
                            break
                        default:
                            print("error in filter")
                            break
                            
                        }
                    }else{
                        self.transData.append(list)
                    }
                }
                    
                }
            }
        }
        configViews()
    }
    func partnerFilterQuery(){
        partnerData = []
        PartnerRepository.shared.getAllPartner { partnerList, str in
            for partner in partnerList{
                if partner.idBusiness == UserDefaults.standard.string(forKey: "businessID") ?? "errorID"{
                    let partnerName = partner.name ?? "errorName"
                    let partnerID = partner.idPartner ?? "errorID"
                    
                    self.partnerData.append([partnerID, partnerName])        }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionDetails{
            let vc = segue.destination as? TransactionDetails
            vc?.inputArray[1] = selectedEntry
            vc?.isEditable = false
        }
    }
    
}




