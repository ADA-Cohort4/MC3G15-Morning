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
    
    
    var selectedEntry : String = ""
    //DUMMY DATA FOR TESTING, NTAR DIAPUS AJA
    //urutan: PartnerName, TRID, Type, Status, Total, NextPayment, idPartner
   //var transData : [[String]] = [["Sinar Jaya", "TR#1028231", "Customer","Pending Payment", "Rp14,000,000", "Jul 31, 2021"], ["Epic Corp", "TR#213123", "Supplier", "Pending Payment", "Rp14,000,000", "Aug 29, 2021"]]
    var transData : [[String]] = []
    // 0 = receivable, 1 = payable
    let queuedPayment : [[Double]] = [[1450000, 2560000, 1440000], [2445000]]
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.tabBarItem.image = UIImage(systemName: "book")
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
//        if self.transData.isEmpty{
//            CommonFunction.shared.addShadow(view: self.addTransactionBtnFirst)
//        }
//
//
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        generateDummyData()
        queryForDashboard()
        print("transaction data: ", transData)
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
        
        if transData.isEmpty {
            receiptImage.isHidden = false
            mainTableView.isHidden = true
            mainTableView.isUserInteractionEnabled = false
            addTransactionBtnFirst.isHidden = false
            addTransactionBtnFirst.layer.cornerRadius = 10
            yourTListEmpty.isHidden = false
            welcomeLabel.isHidden = false
            
        }
        
       
        headerPadding.layer.cornerRadius = 10
        
        //self.navigationController?.isNavigationBarHidden = true
      
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transData.count + 2
    }
    //MARK: TODO: Filter by date
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transData.isEmpty == false{
            
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
            print(transData)
            let dateRemaining = compareDates(dateString: transData[indexPath.row-2][5])
            
            //MARK: Ubah cell text menjadi sesuai transaction
            cell.selectedBackgroundView = UIView()
            //-2 karena ngikutin jumlah cell di dashboard
            cell.partnerNameLabel.text = transData[indexPath.row-2][0]
            cell.TRIDLabel.text = transData[indexPath.row-2][1]
            cell.typeLabel.text = transData[indexPath.row-2][2]
            cell.statusLabel.text = transData[indexPath.row-2][3]
            cell.totalPriceLabel.text = transData[indexPath.row-2][4]
            cell.nextPaymentLabel.text = transData[indexPath.row-2][5]
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
            selectedEntry = transData[indexPath.row-2][1]
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
    
    func queryForDashboard(){
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
                if result.status?.rawValue == "ongoing"{
                let list : [String] = [partnerName, result.idTransaction!, type, result.status!.rawValue,  String(result.totalPrice ?? 0), result.dueDate!]
                
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
    func generateDummyData(){
        let userDefaults = UserDefaults()
        
        if userDefaults.bool(forKey: "isDummy") == false{
            userDefaults.setValue(true, forKey: "isDummy")
        //MARK: -dummy partner
        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "1", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .customer, name: "Panjul", phone: "6281288540387", status: .active, airtableId: "1", address: "Jalan rusun apron", email: "julius@lixus.id", ownerName: "Julius")) { Result in
            if Result.idPartner != "" || Result.idPartner != nil {
                print("save 1")
                DispatchQueue.main.async {
                    
                
                }
                PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "2", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Ricky", phone: "62812885584", status: .active, airtableId: "2", address: "Jalan rusun apron", email: "ricky@abc.com", ownerName: "Ricky")) { Result in
                    if Result.idPartner != "" || Result.idPartner != nil {
                        print("save 2")
                        DispatchQueue.main.async {
                            
                        
                        }
                        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "3", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .customer, name: "Rico", phone: "62812646464", status: .active, airtableId: "3", address: "Jalan rusun apron", email: "abc@abc.com", ownerName: "Rico")) { Result in
                            if Result.idPartner != "" || Result.idPartner != nil {
                                print("save 3")
                                DispatchQueue.main.async {
                                    
                                
                                }
                                PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "4", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Peter", phone: "62817271726", status: .active, airtableId: "4", address: "Jalan rusun apron", email: "def@def.com", ownerName: "Peter")) { Result in
                                    if Result.idPartner != "" || Result.idPartner != nil {
                                        print("save 4")
                                        DispatchQueue.main.async {
                                            
                                        
                                        }
                                        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "5", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Valdo", phone: "62811227722", status: .active, airtableId: "5", address: "Jalan rusun apron", email: "efg@efg.com", ownerName: "Valdo")) { Result in
                                            print("save 5")
                                            print("added partner")
                                        }
                                    } else {
                                        print("error save")
                                    }
                                   
                                }
                            } else {
                                print("error save")
                            }
                        }
                    } else {
                        print("error save")
                    }
                    
                }
            } else {
                print("error save")
            }
            
        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "2", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Ricky", phone: "62812885584", status: .active, airtableId: "2", address: "Jalan rusun apron", email: "ricky@abc.com", ownerName: "Ricky")) { Result in
//            if Result.idPartner != "" || Result.idPartner != nil {
//                print("save 2")
//                DispatchQueue.main.async {
//
//
//                }
//            } else {
//                print("error save")
//            }
//
//        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "3", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .customer, name: "Rico", phone: "62812646464", status: .active, airtableId: "3", address: "Jalan rusun apron", email: "abc@abc.com", ownerName: "Rico")) { Result in
//            if Result.idPartner != "" || Result.idPartner != nil {
//                print("save 3")
//                DispatchQueue.main.async {
//
//
//                }
//            } else {
//                print("error save")
//            }
//        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "4", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Peter", phone: "62817271726", status: .active, airtableId: "4", address: "Jalan rusun apron", email: "def@def.com", ownerName: "Peter")) { Result in
//            if Result.idPartner != "" || Result.idPartner != nil {
//                print("save 4")
//                DispatchQueue.main.async {
//
//
//                }
//            } else {
//                print("error save")
//            }
//
//        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "5", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Valdo", phone: "62811227722", status: .active, airtableId: "5", address: "Jalan rusun apron", email: "efg@efg.com", ownerName: "Valdo")) { Result in
//            print("save 5")
//            print("added partner")
//        }
        //MARK: -transaction dummy
        
        TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XJSHDS", idPartner: "1", totalPrice: 14000000, paymentCount: 2, document: "https://icloud.com", dueDate: "2021-09-08", createdDate: "2021-08-08", updatedDate: "2021-08-15", status: .ongoing, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
            print("added transaction")
        }
        TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XHJSAS", idPartner: "2", totalPrice: 10000000, paymentCount: 2, document: "https://icloud.com", dueDate: "2021-09-30", createdDate: "2021-08-08", updatedDate: "2021-08-30", status: .ongoing, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
            print("added transaction")
        }
        TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "TEST", idPartner: "5", totalPrice: 999999, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-08", createdDate: "2021-07-08", updatedDate: "2021-08-08", status: .paid, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
                    print("added transaction")
        }
        TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XHUSSD", idPartner: "5", totalPrice: 10000000, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-08", createdDate: "2021-07-08", updatedDate: "2021-08-08", status: .paid, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
            print("added transaction")
        }
        TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XJBCZZ", idPartner: "3", totalPrice: 8000000, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-01", createdDate: "2021-07-01", updatedDate: "2021-07-01", status: .waiting, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
            print("added transaction")
        }
        TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XBJEGE", idPartner: "2", totalPrice: 6000000, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-14", createdDate: "2021-07-14", updatedDate: "2021-07-14", status: .waiting, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
            print("added transaction")
        }
        
        //MARK: -dummy payment
        
        PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment: "PSBCBB", idTransaction: "XJSHDS", idUser: UserDefaults.standard.string(forKey: "userID")!, createdDate: "2021-08-15", amount: 8000000, document: "https://icloud.com", airtableId: "1")) { Result in
            print("added payment")
        }
        PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment: "PGHUYU", idTransaction: "XHJSAS", idUser: UserDefaults.standard.string(forKey: "userID")!, createdDate: "2021-08-30", amount: 5000000, document: "https://icloud.com", airtableId: "1")) { Result in
            print("added payment")
        }
        PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment: "PMNBAS", idTransaction: "XHUSSD", idUser: UserDefaults.standard.string(forKey: "userID")!, createdDate: "2021-08-08", amount: 10000000, document: "https://icloud.com", airtableId: "1")) { Result in
            print("added payment")
        }
        }
    }
    
    
   
 
}
