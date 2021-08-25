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
    var cid = "" //"CID: \(String(describing: UserDefaults.standard.string(forKey: "userID")))"
    var profileData : [[String]] = []

    override func viewDidLoad(){
        queryBusiness()
        print(profileData)
        mainTable.dataSource = self
        mainTable.delegate = self
//        mainTable.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        LogOut.layer.cornerRadius = 10
        profilePicture.layer.cornerRadius = 35
    }
    
    //MARK: Edit Data
    @IBAction func editTap(_ sender: UIButton) {
        //bikin alert buat edit text
        //bikin switch case edit[i] buat detect button yang mana
        let count = sender.tag + 1
        print(count)

        switch count{
        case 1: //MARK: Name
            let alert = UIAlertController(title: "Edit Name", message: "Enter a text to make changes", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "\(self.profileData[0][1])"
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
                textField.text = "\(self.profileData[0][2])"
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
                textField.text = "\(self.profileData[0][3])"
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
                textField.text = "\(self.profileData[0][4])"
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
        return profileData.count //error (apa diganti 1 aja?)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mainTable.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
            
        //MARK: Data Profile
        cell.nameLabel.text = self.profileData[0][1]
        cell.addressLabel.text = self.profileData[0][2]
        cell.phoneNumLabel.text = self.profileData[0][3]
        cell.emailLabel.text = self.profileData[0][4]
        self.CID.text = String("CID: \(self.profileData[0][0])")
        self.email.text = self.profileData[0][4]
            
        return cell
    }
    
    func queryBusiness(){
        BusinessRepository.shared.getAllBusiness(UserDefaults.standard.string(forKey: "businessID")!) { resultBusiness, business  in
            print("loop")
            for business in resultBusiness{
                var userId = ""
                var nameLabel = ""
                var addressLabel = ""
                var phoneLabel = ""
                var emailLabel = ""
                UserRepository.shared.getAllUsers { resultUserList, resultString in
                    for resultUser in resultUserList{
                        if resultUser.idUser == business.idUser{
                            print("found User")
                            userId = business.idUser!
                            nameLabel = business.name!
                            addressLabel = business.address!
                            phoneLabel = business.phone!
                            emailLabel = business.email!
                            let list: [String] = [userId, nameLabel, addressLabel, phoneLabel, emailLabel]
                            self.profileData.append(list)
                        } else {
                            print("failed")
                        }
                    }
                }
            }
        }
    }
}

