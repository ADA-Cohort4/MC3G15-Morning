//
//  Dashboard.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

class Dashboard : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var usermodel = UserModel?.self
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerPadding: UIView!
    @IBOutlet weak var addTransactionBtnFirst: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var yourTListEmpty: UILabel!
    
    @IBOutlet weak var receiptImage: UIImageView!
    
    private let refreshControl = UIRefreshControl()
    
    
    var selectedEntry : String = ""
    //DUMMY DATA FOR TESTING, NTAR DIAPUS AJA
    //urutan: PartnerName, TRID, Type, Status, Total, NextPayment, idPartner
   //var Dashboard.transData : [[String]] = [["Sinar Jaya", "TR#1028231", "Customer","Pending Payment", "Rp14,000,000", "Jul 31, 2021"], ["Epic Corp", "TR#213123", "Supplier", "Pending Payment", "Rp14,000,000", "Aug 29, 2021"]]
    static var transData : [[String]] = []
    // 0 = receivable, 1 = payable
    let queuedPayment : [[Double]] = [[1450000, 2560000, 1440000], [2445000]]
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
//            self.navigationController?.tabBarItem.image = UIImage(systemName: "book")
//            self.tabBarController?.tabBarItem.image = UIImage(systemName: "book")
            self.tabBarController?.tabBarItem.title = "Dashboard"
            self.tabBarController?.navigationController?.navigationBar.isHidden = true
            self.title = "Dashboard"
        }
        //MARK: -COPAS KALO MAU ADD PAYMENT
//        PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment:UUID().uuidString , idTransaction: UUID().uuidString, idUser: "1", createdDate: "2021-09-21", amount: 1244000, document: "none", airtableId: "1")) { Result in
//            print(Result)
//        }
        //MARK: -COPAS KALO MAU ADD PARTNER
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "1", idUser: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Epic Partner", phone: "08180261", status: .active, airtableId: "1", address: "jalan goblok", email: "goblok@goblok.com", ownerName: "orang gobs")) { Result in
//            print("added new partner")
//        }
//
//        if self.Dashboard.transData.isEmpty{
//            CommonFunction.shared.addShadow(view: self.addTransactionBtnFirst)
//        }
//
//
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Dashboard.transData = []
        Dashboard.queryForDashboard()
        self.mainTableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        Dashboard.queryForDashboard()
        print("transaction data: ", Dashboard.transData)
        //MARK:Ubah background jadi gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.init(displayP3Red: 17.0/255.0, green: 86.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        yourTListEmpty.isHidden = true
        welcomeLabel.isHidden = true
        addTransactionBtnFirst.isHidden = true
        mainTableView.isHidden = false
        mainTableView.dataSource = self
        mainTableView.delegate = self
        receiptImage.isHidden = true
        
        if Dashboard.transData.isEmpty {
            receiptImage.isHidden = false
            mainTableView.isHidden = true
            mainTableView.isUserInteractionEnabled = false
            addTransactionBtnFirst.isHidden = false
            addTransactionBtnFirst.layer.cornerRadius = 10
            yourTListEmpty.isHidden = false
            welcomeLabel.isHidden = false
            
        }
        refreshControl.addTarget(self, action: #selector(self.onRefreshPull), for: .valueChanged)
        mainTableView.addSubview(refreshControl)
        
        headerPadding.layer.cornerRadius = 10
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dashboard.transData.count + 2
    }
    //MARK: TODO: Filter by date
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Dashboard.transData.isEmpty == false{
            
        switch indexPath.row {
        //cell 0 = date picker, cell 1 = balance, cell 2 = ongoing trans
        case 0:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "dateCell") as! dateCell
            cell.selectedBackgroundView = UIView()
            return cell
           
        case 1:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "balanceCell") as! balanceCell
            cell.selectedBackgroundView = UIView()
            //add target to button add transaction
            cell.addTransactionBtn.addTarget(self, action: Selector("onAddBtnClick"), for: .touchUpInside)
            cell.configBalance(data: queuedPayment)
            return cell
           
        default:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "transactionsCell") as! transactionsCell
            print(Dashboard.transData)
            let dateRemaining = compareDates(dateString: Dashboard.transData[indexPath.row-2][5])
            
            //MARK: Ubah cell text menjadi sesuai transaction
            cell.selectedBackgroundView = UIView()
            //-2 karena ngikutin jumlah cell di dashboard
            let count = Dashboard.transData.count
            //mulai dari paling baru dibuat
            cell.partnerNameLabel.text = Dashboard.transData[indexPath.row-2][0]
            cell.TRIDLabel.text = Dashboard.transData[indexPath.row-2][1]
            cell.typeLabel.text = Dashboard.transData[indexPath.row-2][2]
            cell.statusLabel.text = Dashboard.transData[indexPath.row-2][3]
            cell.totalPriceLabel.text = Dashboard.transData[indexPath.row-2][4]
            cell.nextPaymentLabel.text = Dashboard.transData[indexPath.row-2][5]
            cell.dueLabel.text = "Due in \(dateRemaining)d"
            switch dateRemaining { //ubah due alert color tergantung berapa hari sisa
            case "0", "1", "2":
                cell.dueLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.dueAlertIcon.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                break
            case "3", "4", "5", "6", "7":
                cell.dueLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.dueAlertIcon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            default:
                if Int(dateRemaining)! > 0{
                cell.dueLabel.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                    cell.dueAlertIcon.isHidden = true
                    
                } else{
                    cell.dueLabel.text = "Payment Due"
                    cell.dueLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    cell.dueAlertIcon.isHidden = false
                }
            }
            if dateRemaining == "0" { cell.dueLabel.text = "Due Today"}
            
           
            return cell
        
        }
        } else{
            return UITableViewCell()
        }
    }
    @IBAction func onAddBtnClick() {
       // move to add transaction storyboard
        performSegue(withIdentifier: "toAddTransaction", sender: nil)
        
    }
    @IBAction func onFirstAddBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "toAddTransaction", sender: nil)
    }
    
    func compareDates(dateString: String) -> String{
        //func untuk calculate due time left
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-mm-dd"
        dateFormatter.dateFormat = "MMM d, yyyy"
       
        let dateDue = (dateFormatter.date(from: dateString) ?? dateFormatter2.date(from: dateString)) ?? Date()
        let dateDiff : Int = Calendar.current.dateComponents([.day], from: Date(), to: dateDue).day!
        return "\(dateDiff)"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //Untuk force height tiap2 cell di dashboard
        switch indexPath.row {
        case 0:
            return CGFloat(180)
        case 1:
            return CGFloat(305)
        default:
            return CGFloat(270)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0,1:
            print("Index date filter / balance clicked")
        default:
            selectedEntry = Dashboard.transData[indexPath.row-2][1]
            performSegue(withIdentifier: "toTransactionDetail", sender: nil)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionDetails{
            let vc = segue.destination as? TransactionDetails
            //VC INPUT ARRAY ADALAH TRID
            vc?.inputArray[1] = selectedEntry
        }
    }
    
    static func queryForDashboard(){
        // MARK: -QUERY TRANSACTION FOR DASHBOARD
        TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) { transactionArr, err in
            print(transactionArr)
            for transaction in transactionArr{
                var partnerName = ""
                var type = ""
                PartnerRepository.shared.getAllPartner { resultPartnerList, resultString in
                    for resultPartner in resultPartnerList{
                        if resultPartner.idPartner == transaction.idPartner{
                            print("found partner")
                            partnerName = resultPartner.name!
                            type = resultPartner.type?.rawValue ?? "customer"
                        }
                    }
                }
                if (transaction.status?.rawValue == "ongoing" || transaction.status?.rawValue == "waiting") {
                    let list : [String] = [partnerName, transaction.idTransaction!, type, transaction.status!.rawValue,  String(transaction.totalPrice ?? 0), transaction.dueDate ?? "1990-01-01"]
                    
                    var dashboardQueryHasSameID : Bool = false
                    
                    for transaction in Dashboard.transData{
                        if list[1] == transaction[1]{
                            dashboardQueryHasSameID = true
                        }
                    }
                    
                    if dashboardQueryHasSameID == false{
                        Dashboard.transData.append(list)
                        
                    }
                }
            }
        }
    }
    
    @IBAction func onRefreshPull(){
        Dashboard.transData = []
        Dashboard.queryForDashboard()
        mainTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}
