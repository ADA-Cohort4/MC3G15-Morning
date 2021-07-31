//
//  APIRequest.swift
//  Rekord
//
//  Created by Julius Cesario on 30/07/21.
//

import Foundation

class APIRequest: NSObject{
    
    //LOGIN METHOD USING NETWORK
    static func getUsersData(url:String,
                             filter:String,
                             header: [String: String],
                             showLoader: Bool,
                             successCompletion: @escaping (UsersNetworkData)->Void,
                             failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.GET(url: url, filter: filter, header: header, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.USERSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let usersModel = try JSONDecoder().decode(UsersNetworkData.self, from: response as! Data)
                dataModel = usersModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END LOGIN NETWORK
    
    
    
    
}
