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
    
    static var transData : [[String]] = []
    // 0 = receivable, 1 = payable
    var queuedPayment : [[Double]] = [[], []]
    //    var inPayment : Double = 0
    //    var outPayment : Double = 0
    static var startDate : Date = Date()
    static var endDate : Date = Date()
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            
            self.tabBarController?.tabBarItem.title = "Dashboard"
            self.tabBarController?.navigationController?.navigationBar.isHidden = true
            self.title = "Dashboard"
        }
        
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
                cell.filterBtn.addTarget(self, action: #selector(self.onFilterBtnClick), for: .touchUpInside)
                return cell
                
            case 1:
                let cell = mainTableView.dequeueReusableCell(withIdentifier: "balanceCell") as! balanceCell
                cell.selectedBackgroundView = UIView()
                //add target to button add transaction
                cell.addTransactionBtn.addTarget(self, action: #selector(self.onAddBtnClick), for: .touchUpInside)
                
                
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
    @IBAction func onFilterBtnClick(){
        
        queryForBalance()
        mainTableView.reloadData()
    }
    @IBAction func onFirstAddBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "toAddTransaction", sender: nil)
    }
    
    func compareDates(dateString: String) -> String{
        //func untuk calculate due time left
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let dateDue = (dateFormatter.date(from: dateString) ?? dateFormatter2.date(from: dateString)) ?? Date()
        let dateDiff : Int = Calendar.current.dateComponents([.day], from: Date(), to: dateDue).day!
        return "\(dateDiff)"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //Untuk force height tiap2 cell di dashboard
        switch indexPath.row {
        case 0:
            return CGFloat(220)
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
    func queryForBalance(){ // TEMPORARY NTAR DIGANTI JADI OUTGOING  / INGOING
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        PaymentRepository.shared.getAllPayment(UserDefaults.standard.string(forKey: "userID") ?? "errorID") { paymentList, str in
            for payment in paymentList{
                print("found payment list")
                let paymentDate : Date = formatter.date(from: payment.createdDate ?? "1990-02-02") ?? Date()
                print(paymentDate)
                if paymentDate.isWithinFilterDate(date: Dashboard.startDate, andDate: Dashboard.endDate){
                    print("found payment for filter")
                    TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID") ?? "errorBusiness") { trList, str in
                        for transaction in trList{
                            if transaction.idTransaction == payment.idTransaction{
                                
                                switch transaction.type{
                                case .incoming:
                                    self.queuedPayment[0].append(payment.amount ?? 0)
                                    break
                                case .outgoing:
                                    self.queuedPayment[1].append( payment.amount ?? 0)
                                    break
                                default:
                                    print("error type of partner")
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    static func queryForDashboard(){
        // MARK: -QUERY TRANSACTION FOR DASHBOARD
        TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID")!) { transactionArr, err in
            print(transactionArr)
            for transaction in transactionArr{
                var partnerName = ""
                let type = transaction.type?.rawValue ?? "incoming"
                PartnerRepository.shared.getAllPartner { resultPartnerList, resultString in
                    for resultPartner in resultPartnerList{
                        if resultPartner.idPartner == transaction.idPartner{
                            print("found partner")
                            partnerName = resultPartner.name!
                            //  type = resultPartner.type?.rawValue ?? "customer"
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
extension Date{
    func isWithinFilterDate(date startDate : Date, andDate endDate : Date) -> Bool{
        return (min(startDate, endDate)...max(startDate, endDate)).contains(self)
    }
}
