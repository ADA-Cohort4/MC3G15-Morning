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
    
    @IBOutlet weak var filterView: FilterView!
    
    
    //nanti data hasil query masukin sini, kalo filter / search reload view dan restart query
    //URUTAN: 0 = partner name, 1 = trid, 2 = type, 3 = status, 4 = total
    let transData : [[String]] = [["Sinar Jaya", "TR#1028231", "Customer","Pending Payment", "Rp14,000,000"], ["Epic Corp", "TR#213123", "Supplier", "Pending Payment", "Rp14,000,000"]]
    let customerData : [String] = ["Sinar Jaya", "Epic Corp"]
    let typeData : [String] = ["Customer", "Supplier"]
    var selectedCustomerData : String = ""
    var selectedFilter : String = ""
    
    var filterViewShown : Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        historyTable.dataSource = self
        historyTable.delegate = self
        configViews()
        //filterView.customerData = customerData
        //add target for filter buttons
        typeDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("onTypeFilterClick")))
        partnerDrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("onPartnerFilterClick")))
        //add target for done button in filter view
        filterView.doneBtn.addTarget(self, action: Selector("onFilterDoneBtnClick"), for: .touchUpInside)
        
    }
    
    func configViews(){
        filterView.layer.cornerRadius = 10
        filterView.baseView.layer.cornerRadius = 10
        filterTypeLabel.text = "Type"
        filterPartnerLabel.text = "Partner"
        dateDrop.layer.cornerRadius = 10
        partnerDrop.layer.cornerRadius = 10
        typeDrop.layer.cornerRadius = 10
        
        headerPadding.layer.cornerRadius = 10
        
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
        cell.partnerNameLabel.text = transData[indexPath.row][0]
        cell.transactionIDLabel.text = transData[indexPath.row][1]
        cell.typeLabel.text = transData[indexPath.row][2]
        cell.statusLabel.text = transData[indexPath.row][3]
        cell.totalPriceLabel.text = transData[indexPath.row][4]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func onFilterDoneBtnClick(){
        
        if filterView.selectedOption != "" {
            selectedCustomerData = filterView.selectedOption
            switch selectedFilter{
            case "partner":
                filterPartnerLabel.text = selectedCustomerData
                break
            case "date":
                
                break
            case "type":
                filterTypeLabel.text = selectedCustomerData
                break
            default:
                print("Error")
            }
        }
        
       
        filterView.isHidden = true
        containerView.mask = nil
        
    }
    @IBAction func onTypeFilterClick(){
        selectedFilter = "type"
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
    
}

