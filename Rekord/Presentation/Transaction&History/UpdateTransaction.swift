//
//  UpdateTransaction.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 04/08/21.
//

import UIKit

class UpdateTransaction: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var AmountPaidCell: UIView!
    @IBOutlet weak var TermOfPaymentCell: UIView!
    
    @IBOutlet weak var PaymentStatus: UITableView!
    @IBOutlet weak var uploadDocumentButton: UIButton!
    @IBOutlet weak var amountPaid: UITextField!
    @IBOutlet weak var termOfPayment: UITextField!
    @IBOutlet weak var voidTranasctionButton: UIButton!
    
    @IBOutlet weak var updatePaymentBtn: UIButton!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    var imageName = ""
    var imagePicker: UIImagePickerController!
    var selectedTransaction : String = ""
    var finalPayment : Bool = false
    var totalDue : Double = 0
    let alertSave = UIAlertController(title: "Saving your payment...", message: nil, preferredStyle: .alert)
    
    
    override func viewDidLoad() {
//        PaymentStatus.register(UINib.init(nibName: "PaymentStatusCell", bundle: nil), forCellReuseIdentifier: "PaymentStatusCell")
//        PaymentStatus.reloadData()
        
        self.hideKeyboardWhenTappedAround()
        AmountPaidCell.layer.cornerRadius = 10
       // TermOfPaymentCell.layer.cornerRadius = 10
        UploadDocumentView.layer.cornerRadius = 10
        voidTranasctionButton.layer.cornerRadius = 10
        updatePaymentBtn.layer.cornerRadius = 10
        amountPaid.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        print("final payment: ", finalPayment, "total due: ", totalDue)
    }
    
    @objc func editingChanged() {
        amountPaid.text = self.amountPaid.text?.currencyInputFormatting()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PaymentStatus.dequeueReusableCell(withIdentifier: "PaymentStatusCell", for: indexPath)as! PaymentStatusCell
        return cell
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func uploadProofClick(_ sender: Any) {
        selectImageFrom(.photoLibrary)
    }
    
    
    @IBAction func onUpdateBtnClick(_ sender: Any) {
        print("attempting to save the transaction....")
        if finalPayment == true{
            if Double(amountPaid.text ?? "0") == totalDue{
            let alert = UIAlertController(title: "Final Payment Confirmation", message: "You are about to enter the final payment. Are you sure you want to finalize this transaction? The transaction will no longer be updateable.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alertAction in
               
                self.savePayment()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true) {
                    return
                }
            }))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                let alert = UIAlertController(title: "Adjust the payment amount value", message: "Your final payment amount isn't equal to the due amount. Please adjust the value according to the due amount..", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { act in
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            savePayment()
        }
    }
    func savePayment(){
        
        if let imageData = self.UploadDocumentView.image?.jpegData(compressionQuality: 0.1){
            imageBase64String = imageData.base64EncodedString()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let newDate =  dateFormatter.string(from: Date())
        let newPayment = PaymentModel(idPayment: CommonFunction.shared.randomString(length: 10), idTransaction: selectedTransaction, idUser: UserDefaults.standard.string(forKey: "userID") ?? "errorUser", createdDate: newDate, amount: Double(amountPaid.text ?? "0") ?? 0, document: "none", airtableId: "1")
        self.present(alertSave, animated: true, completion: nil)
        
        PaymentRepository.shared.savePayments(payment: newPayment) { payment in
            
            if self.finalPayment == true {
                print("finalizing transaction....")
                self.finalizeTransaction()
            } else{
                self.alertSave.dismiss(animated: true, completion: nil)
                let alert2 = UIAlertController(title: "Your payment and transaction has been saved.", message: nil, preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    if self.finalPayment == false{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }))
                self.present(alert2, animated: true, completion: nil)
                
            }
            }
            
        }
    func finalizeTransaction(){
       //untuk ganti trstatus menjadi paid
        print("starting finalization...")
       
        TransactionRepository.shared.getAllTransaction(_idBusiness: UserDefaults.standard.string(forKey: "businessID") ?? "Error") { trList, str in
            for trans in trList{
                if trans.idTransaction == self.selectedTransaction{
                    let updateTrans : TransactionModel = trans
                    updateTrans.status = .paid
                    TransactionRepository.shared.updateTransaction(transaction: updateTrans) { isFinalized in
                        self.alertSave.dismiss(animated: true, completion: nil)
                        let alert2 = UIAlertController(title: "Your transaction has been finalized.", message: nil, preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert2, animated: true, completion: nil)
                        print ("finalized")
                    }
                }
            }
        }
      
        
    }
    
    
}

