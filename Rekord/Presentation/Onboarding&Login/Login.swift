//
//  Login.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit


class Login: UIViewController {
    var email = "lixus.julius17@gmail.com"
    var passcode = "123456"
    
    
    // variable to store the data response that will be displayed
    var userModel: UsersNetworkData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLearningData()
    }
    
    func loadLearningData(){
        // set the header parameter
        
        //let filter = "Users?filterByFormula=AND(email%3D%22\(email)%22%2Cpasscode%3D%22\(passcode)%22)"
        let filter = "Users"
        let url = Constants.NETWORK_URL
        // fetch the data from API
        APIRequest.getUsersData(url: url, filter: filter, header: Constants.HEADER_URL, showLoader: true) { response in
            print(response)
            // handle response and store it to the data model
            self.userModel = response
            DispatchQueue.main.async {
                print(self.userModel as Any)
            }
        } failCompletion: { message in
            // display alert failure
            // dismiss loader
            print(message)
        }
    }
}
