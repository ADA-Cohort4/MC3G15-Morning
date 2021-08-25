//
//  Settings.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

class Profile: UIViewController{
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var CID: UILabel!
    @IBOutlet weak var LogOut: UIButton!
    @IBOutlet var baseView: [UIView]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var button: [UIButton]!
    
    private let refreshControl = UIRefreshControl()
    
    var profileData : BusinessModel = BusinessModel(idBusiness: "noIDb", idUser: "noIduser", name: "noName", email: "noEmail", phone: "noPhone", address: "noAddress", airtableId: "noAirTable", status: "noStatus")

    override func viewDidLoad(){
        queryBusiness()
        print(profileData)
        for i in 0..<5 {
            baseView[i].layer.cornerRadius = 10
            CommonFunction.shared.addShadow(view: baseView[i])
        }
        LogOut.layer.cornerRadius = 10
        profilePicture.layer.cornerRadius = 35
    }
    
    //MARK: Edit Data
    @IBAction func editName(_ sender:UIButton){
        //MARK: Name
        let alert = UIAlertController(title: "Edit Name", message: "Enter a text to make changes", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "\(self.profileData.name)"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            print("User text: \(userText)")
            self.profileData.name = userText
            BusinessRepository.shared.updateBusiness(profileData){ (result) in
                if result.airtableId != "" || result.airtableId != nil {
                    DispatchQueue.main.async {
                        
                    
                    }
                } else {
                    print("error save")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true) {
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editAddress(_ sender:UIButton){
        //MARK: Address
            let alert = UIAlertController(title: "Edit Address", message: "Enter a text to make changes", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "\(self.profileData.address)"
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                print("User text: \(userText)")
                self.profileData.address = userText
                BusinessRepository.shared.updateBusiness(profileData){ (result) in
                    if result.airtableId != "" || result.airtableId != nil {
                        DispatchQueue.main.async {
                            
                        
                        }
                    } else {
                        print("error save")
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true) {
                    return
                }
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editPhone(_ sender:UIButton){
        //MARK: Phone Number
        let alert = UIAlertController(title: "Edit Phone Number", message: "Enter a text to make changes", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "\(self.profileData.phone)"
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            print("User text: \(userText)")
            self.profileData.phone = userText
            BusinessRepository.shared.updateBusiness(profileData){ (result) in
                if result.airtableId != "" || result.airtableId != nil {
                    DispatchQueue.main.async {
                        
                    
                    }
                } else {
                    print("error save")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true) {
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editEmail(_ sender:UIButton){
        //MARK: Email
        let alert = UIAlertController(title: "Edit Email", message: "Enter a text to make changes", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "\(self.profileData.email)"
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            print("User text: \(userText)")
            self.profileData.email = userText
            BusinessRepository.shared.updateBusiness(profileData){ (result) in
                if result.airtableId != "" || result.airtableId != nil {
                    DispatchQueue.main.async {
                        
                    
                    }
                } else {
                    print("error save")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true) {
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Logout
    @IBAction func Logout(_ sender: Any) {
        //logout
        //navigate to login
        
    }
    
    func loadData(business: BusinessModel) {
        nameLabel.text = business.name
        addressLabel.text = business.address
        phoneNumLabel.text = business.phone
        emailLabel.text = business.email
        self.CID.text = String("CID: \(business.idBusiness)")
        self.email.text = String("\(business.email)")
    }
    
    func queryBusiness(){
        BusinessRepository.shared.getAllBusiness(UserDefaults.standard.string(forKey: "userID")) { businessList, str in
            for business in businessList{
                if business.idBusiness == UserDefaults.standard.string(forKey: "businessID"){
                    loadData(business: business)
                    self.profileData = business
                }

            }
        }
    }
}

