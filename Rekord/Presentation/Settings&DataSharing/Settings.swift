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
    var emailLabel = ""
    var profileData : [[String]] = []

    override func viewDidLoad(){
        mainTable.dataSource = self
        mainTable.delegate = self
        LogOut.layer.cornerRadius = 10
        profilePicture.layer.cornerRadius = 35
    }
    
    //MARK: Edit
    @IBAction func editTap(_ sender: Any) {
        
    }
    
    //MARK: Logout
    @IBAction func Logout(_ sender: Any) {
        //logout
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mainTable.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
            
        //MARK: Data Profile
        BusinessRepository.shared.getBusiness(<#String#>){ resultUser in
            if self.userId == resultUser.idUser{
                cell.selectedBackgroundView = UIView()
                cell.nameLabel.text = resultUser.name
                cell.addressLabel.text = resultUser.address
                cell.phoneNumLabel.text = resultUser.phone
                cell.emailLabel.text = resultUser.email
                self.CID.text = String("CID: \(resultUser.idUser)")
                self.email.text = resultUser.email
            }
        }
    }
}

