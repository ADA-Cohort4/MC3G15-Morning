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
    //urutan: PartnerName, TRID, Type, Status, Total, NextPayment
   let transData : [[String]] = [["Sinar Jaya", "TR#1028231", "Customer","Pending Payment", "Rp14,000,000", "Jul 31, 2021"], ["Epic Corp", "TR#213123", "Supplier", "Pending Payment", "Rp14,000,000", "Aug 29, 2021"]]
  //let transData : [[String]] = []
    // 0 = receivable, 1 = payable
    let queuedPayment : [[Double]] = [[1450000, 2560000, 1440000], [2445000]]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBarItem.image = UIImage(systemName: "book")
        self.tabBarController?.tabBarItem.title = "Dashboard"
        self.title = "Dashboard"
        
        if transData.isEmpty{
            CommonFunction.shared.addShadow(view: addTransactionBtnFirst)
        }
     
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(transData)
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
                cell.dueLabel.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                cell.dueAlertIcon.isHidden = true
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
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateDue = dateFormatter.date(from: dateString)!
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
            vc?.inputArray[1] = selectedEntry
        }
    }
    
    
   
 
}
