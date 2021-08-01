//
//  Login.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit


class Login: UIViewController {
    //parameter that need to filter logic
    var email = "lixus.julius17@gmail.com"
    var passcode = "123456"

    // prepare json data
    var jsonData: Data?

    // variable to store the data response that will be displayed
    var userModel: UsersNetworkData?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLearningData()
    }
    
    func loadLearningData(){
        
            // set the json parameter to send
            let json: [String:Any] = [
                "fields" : [
                    "id_user": UUID().uuidString,
                    "apple_id": "axlwibisono@gmail.com",
                    "passcode": "123456",
                    "name": "Axal",
                    "role": "edit",
                    "email": "axlwibisono@gmail.com",
                    "phone": "6281288540387"
                ]
            ]
            //change type data array to json so our api can retrieve it
            do {
                jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            //for getting method spesific data
            let formula = "?filterByFormula=AND(email%3D%22\(email)%22%2Cpasscode%3D%22\(passcode)%22)"
            
            // for filtering tabledata
            let filter = "Users"
            
            //URL Constant
            let url = Constants.NETWORK_URL
            
            // STARTING LOGIC
            // fetch the data from API
            // This is logic to check if users that want to be registered already exist or not
            APIRequest.getUsersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
                // handle response and store it to the data model
                self.userModel = response
                // check if user model not empty means data is exist
                if self.userModel?.records?.isEmpty == true{
                    // post the data to API
                    APIRequest.createUser(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
                        //handle if success
                        print(response)
                    } failCompletion: { message in
                        //handle of failure
                        //display alert failure
                        //dismiss
                        print(message)
                    }
                    }
            } failCompletion: { message in
                // display alert failure
                // dismiss loader
                print(message)
            }
    }
}
