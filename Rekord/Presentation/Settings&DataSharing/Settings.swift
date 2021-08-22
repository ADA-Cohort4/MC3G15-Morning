//
//  Settings.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import Foundation
import UIKit

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var CID: UILabel!
    @IBOutlet weak var LogOut: UIButton!
    
    private let refreshControl = UIRefreshControl()
    
    var userName = ""
    var cid = ""
    var userId = ""
    var nameLabel = ""
    var addressLabel = ""
    var phoneLabel = ""
    var emailLabel = ""
    var profileData : [[String]] = []

    override func viewDidLoad(){
        mainTable.dataSource = self
        mainTable.delegate = self
        LogOut.layer.cornerRadius = 10
        profilePicture.layer.cornerRadius = 35
    }
    
    //MARK: Edit Data
    @IBAction func editTap(_ sender: UIButton) {
        //bikin alert buat edit text
        //bikin switch case edit[i] buat detect button yang mana
        let count = sender.tag + 1

        switch count{
        case 1: //MARK: Name
            let alert = UIAlertController(title: "Edit Name", message: "Enter a text to make changes", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "\(self.nameLabel)"
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                print("User text: \(userText)")
    //            BusinessRepository.updateBusiness //save
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true) {
                    return
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            //save ke repository (update Data)
            
            return
        case 2: //MARK: Address
            let alert = UIAlertController(title: "Edit Address", message: "Enter a text to make changes", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "\(self.addressLabel)"
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                print("User text: \(userText)")
    //            BusinessRepository.updateBusiness //save
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true) {
                    return
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            //save ke repository (update Data)
            
            return
        case 3: //MARK: Phone Number
            let alert = UIAlertController(title: "Edit Phone Number", message: "Enter a text to make changes", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "\(self.phoneLabel)"
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                print("User text: \(userText)")
//                BusinessRepository.updateBusiness //save
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true) {
                    return
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            //save ke repository (update Data)
            
            return
        case 4: //MARK: Email
            let alert = UIAlertController(title: "Edit Email", message: "Enter a text to make changes", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "\(self.emailLabel)"
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                print("User text: \(userText)")
    //            BusinessRepository.updateBusiness //save
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true) {
                    return
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            //save ke repository (update Data)
            
            return
        default:
            return
        }
    }
    
    //MARK: Logout
    @IBAction func Logout(_ sender: Any) {
        //logout
        //navigate to login
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mainTable.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
            
        //MARK: Data Profile
        BusinessRepository.shared.getBusiness(UserDefaults.standard.string(forKey: "businessID")!){ resultUser in
            if self.userId == resultUser.idUser{
                cell.selectedBackgroundView = UIView()
                cell.nameLabel.text = resultUser.name
                cell.addressLabel.text = resultUser.address
                cell.phoneNumLabel.text = resultUser.phone
                cell.emailLabel.text = resultUser.email
                self.CID.text = String("CID: \(resultUser.idUser)")
                self.email.text = resultUser.email
                self.nameLabel = resultUser.name!
                self.addressLabel = resultUser.address!
                self.phoneLabel = resultUser.phone!
                self.emailLabel = resultUser.email!
            }
        }
        return cell
    }
}
