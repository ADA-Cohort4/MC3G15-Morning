//
//  AddTransaction.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit
import EasyTipView
import UserNotifications

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
}()

enum ImageSource {
    case photoLibrary
    case camera
}

class AddTransaction: UIViewController, EasyTipViewDelegate {
    @IBOutlet weak var selectPartner: UITextField!
    @IBOutlet weak var partnerTypePickerView: UIPickerView!
    @IBOutlet weak var totalPrice: UITextField!
    @IBOutlet weak var invoiceView: UIImageView!
    @IBOutlet weak var paymentCount: UITextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var infoButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    var imageName = ""
    var partnerList: [PartnerModel] = []
    var selectedPartnerId: String?
    let paymentCountPickerView = UIPickerView()
    var dueDateNotif: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        partnerTypePickerView.dataSource = self
        partnerTypePickerView.delegate = self
        paymentCountPickerView.dataSource = self
        paymentCountPickerView.delegate = self
        selectPartner.inputView = partnerTypePickerView
        paymentCount.inputView = paymentCountPickerView
        self.tabBarController?.tabBar.isHidden = true
        partnerTypePickerView.isHidden = true
        self.datePickerTextField.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction))
        totalPrice.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.getPartnerList()
        self.view.endEditing(true)
        self.initiateTooltip()
    }
    
    func initiateTooltip() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = .black
        preferences.drawing.backgroundColor = .white
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        preferences.drawing.borderWidth = 1
        preferences.drawing.borderColor = .black
        EasyTipView.globalPreferences = preferences
    }
    
    @objc func cancelAction() {
        self.datePickerTextField.resignFirstResponder()
    }

    @objc func doneAction() {
        if let datePickerView = self.datePickerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dueDateNotif = datePickerView.date
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
            if (resultPartnerList.count == 0) {
                let alert = UIAlertController(title: "Error", message: "You don't have any partner yet, add your partner first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
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
        let newTransaction = TransactionModel(idTransaction: CommonFunction.shared.randomString(length: 8), idPartner: partnerId, totalPrice: Double(originalAmount) ?? 0, paymentCount: Int(paymentCount.text ?? "1")!, document: self.imageName , dueDate: datePickerTextField.text ?? "", createdDate: today, updatedDate: today, status: .waiting, type: .incoming, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID") ?? "errorID")
        repeat {
            newTransaction.idTransaction = CommonFunction.shared.randomString(length: 8)
        } while !TransactionRepository.shared.checkTransactionId(id: newTransaction.idTransaction!)
        
        
        
        let alert = UIAlertController(title: "Saving Transaction...", message: "Please wait while we save your transaction.", preferredStyle: .alert)
        self.present(alert, animated: true)
        TransactionRepository.shared.saveTransaction(transaction: newTransaction){ (result) in
            if result.airtableId != "" || result.airtableId != nil {
                DispatchQueue.main.async {
                    
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                alert.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Error", message: "There was an error in saving your transaction. Try checking your internet connection or restarting the app.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                print("error save")
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success{
                self.scheduleNotif()
                print("success")
            } else if let error = error {
                print("error")
            }
        })
        
        
        
        
    }
    
    func scheduleNotif(){
        let content = UNMutableNotificationContent()
        content.title = "Rekord"
        content.sound = .default
        content.body = "You have a payment due today"
        
        let targetDate = dueDateNotif
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate!), repeats: false)
        
        let request = UNNotificationRequest(identifier: "test_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("error notif")
            }
        })
    }
    
    
    
    @IBAction func startSelectPartner(_ sender: Any) {
        partnerTypePickerView.isHidden = false
    }
    
    @IBAction func paymentCountInfo(_ sender: Any) {
        let text = "Payment count is the number of payment will be done when the total price completed. Tap to dismiss."
        EasyTipView.show(forView: self.infoButton,
            withinSuperview: self.navigationController?.view,
            text: text,
            delegate : self)
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        print("Did dismis")
    }
    
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        print("didtap")
    }
    
    
}

extension AddTransaction: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === paymentCountPickerView {
            return 10
        }
        return partnerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === paymentCountPickerView {
            return "\(row+1)"
        }
        return partnerList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === paymentCountPickerView {
            paymentCount.text = "\(row+1)"
            paymentCount.resignFirstResponder()
        } else {
            selectPartner.text = partnerList[row].name
            selectPartner.resignFirstResponder()
            self.selectedPartnerId = partnerList[row].idPartner
        }
        
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
