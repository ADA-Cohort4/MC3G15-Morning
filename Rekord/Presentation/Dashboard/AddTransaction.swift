//
//  AddTransaction.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
}()

enum ImageSource {
    case photoLibrary
    case camera
}

class AddTransaction: UIViewController {
    
    @IBOutlet weak var selectPartner: UITextField!
    @IBOutlet weak var partnerType: UIPickerView!
//    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var totalPrice: UITextField!
    @IBOutlet weak var invoiceView: UIImageView!
//    @IBOutlet weak var dueDateView: UIView!
    @IBOutlet weak var paymentCount: UITextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var imageName = ""
    var partnerList: [PartnerModel]!
    var selectedPartnerId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        partnerType.dataSource = self
        partnerType.delegate = self
        selectPartner.inputView = partnerType
        self.tabBarController?.tabBar.isHidden = true
        partnerType.isHidden = true
        self.datePickerTextField.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction))
//        datePicker.datePickerMode = .date
//        totalPrice.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
//        dueDateView.layer.cornerRadius = 4
        self.getPartnerList()
    }
    
    @objc func cancelAction() {
        self.datePickerTextField.resignFirstResponder()
    }

    @objc func doneAction() {
        if let datePickerView = self.datePickerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.datePickerTextField.text = dateString
                
            print(datePickerView.date)
            print(dateString)
                
            self.datePickerTextField.resignFirstResponder()
        }
    }
    
    func getPartnerList() {
        PartnerRepository.shared.getAllPartner { resultPartnerList, resultString in
            print("resultPartnerList")
            print(resultPartnerList[0].idPartner, resultPartnerList[0].ownerName)
            self.partnerList = resultPartnerList
        }
        
    }
    
    @IBAction func selectInvoice(_ sender: Any) {
        selectImageFrom(.photoLibrary)
    }
    
    @objc func editingChanged() {
        totalPrice.text = self.totalPrice.text?.currencyInputFormatting()
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
    
    @IBAction func createTransaction(_ sender: Any) {

//        let newTransaction = TransactionModel(idTransaction: CommonFunction.shared.randomString(length: 8), idPartner: "1", totalPrice: Double(Float(totalPrice.text ?? "0") ?? 0), paymentCount: 2, document: imageName , dueDate: dateFormatter.string(from: datePicker.date), createdDate: "1998-02-02", updatedDate: "1998-02-02", status: .waiting, airtableId: "1",idBusiness: "1")
        let partnerId = selectedPartnerId ?? (partnerList[0].idPartner ?? "0")
        guard let amount = totalPrice.text else {
            return
        }
        
        //DATE FORMATTER
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: date)
        
        let originalAmount = amount.getOriginalAmount(pattern: CommonFunction.shared.getRegexForAmount())
        print("originalAmount = \(originalAmount)")
        let newTransaction = TransactionModel(idTransaction: CommonFunction.shared.randomString(length: 8), idPartner: partnerId, totalPrice: Double(originalAmount) ?? 0, paymentCount: Int(paymentCount.text ?? "1")!, document: self.imageName , dueDate: datePickerTextField.text ?? "", createdDate: today, updatedDate: today, status: .waiting, airtableId: "1",idBusiness: UserDefaults.standard.string(forKey: "businessID")!)
        repeat {
            newTransaction.idTransaction = CommonFunction.shared.randomString(length: 8)
        } while !TransactionRepository.shared.checkTransactionId(id: newTransaction.idTransaction!)
        
        
        TransactionRepository.shared.saveTransaction(transaction: newTransaction){ (result) in
            if result.airtableId != "" || result.airtableId != nil {
                DispatchQueue.main.async {
                    do{
                        sleep(2)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("error save")
            }
        }
    }
    
    @IBAction func startSelectPartner(_ sender: Any) {
        partnerType.isHidden = false
    }
    
    
}

extension AddTransaction: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return partnerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return partnerList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectPartner.text = partnerList[row].name
        selectPartner.resignFirstResponder()
        self.selectedPartnerId = partnerList[row].idPartner
        self.view.endEditing(true)
    }
    
}

extension AddTransaction: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imageName = url.lastPathComponent
            print("imageName = \(imageName)")
        }

        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let imageData = selectedImage.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)

        //Retrieving the image
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths2               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths2.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
            if let imageRetrieved = UIImage(contentsOfFile: imageURL.path) {
                //do whatever you want with this image
                print(imageRetrieved)
            }
        }
        invoiceView.image = selectedImage
    }
    
}
