//
//  APIRequest.swift
//  Rekord
//
//  Created by Julius Cesario on 30/07/21.
//

import Foundation

class UsersAPIRequest: NSObject{
    
    //GET USERS METHOD USING NETWORK
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
    //END GET USERS NETWORK
    
    //CREATE USER USING NETWORK
    static func createUser(url:String,
                           filter:String,
                           header: [String: String],
                           jsonData: Data,
                           showLoader: Bool,
                           successCompletion: @escaping (UsersNetworkData)->Void,
                           failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.POST(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
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
    //END CREATE USER NETWORK
    
    //PATCH USER USING NETWORK
    static func editUser(url:String,
                         filter:String,
                         header: [String: String],
                         jsonData: Data,
                         showLoader: Bool,
                         successCompletion: @escaping (UsersNetworkData)->Void,
                         failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.PATCH(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
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
    //END PATCH USER NETWORK
    
     
}
