//
//  BusinessAPIReques.swift
//  Rekord
//
//  Created by Julius Cesario on 01/08/21.
//

import Foundation

class BusinessAPIRequest: NSObject{
    
    //GET BUSINESS METHOD USING NETWORK
    static func getBusinessesData(url:String,
                             filter:String,
                             header: [String: String],
                             showLoader: Bool,
                             successCompletion: @escaping (TransactionsNetworkData)->Void,
                             failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.GET(url: url, filter: filter, header: header, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.TRANSACTIONSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let transactionsModel = try JSONDecoder().decode(TransactionsNetworkData.self, from: response as! Data)
                dataModel = transactionsModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END GET BUSINESS NETWORK
    
    //CREATE BUSINESS USING NETWORK
    static func createBusiness(url:String,
                           filter:String,
                           header: [String: String],
                           jsonData: Data,
                           showLoader: Bool,
                           successCompletion: @escaping (TransactionsNetworkData)->Void,
                           failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.POST(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.TRANSACTIONSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let transactionsModel = try JSONDecoder().decode(TransactionsNetworkData.self, from: response as! Data)
                dataModel = transactionsModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END CREATE BUSINESS NETWORK
    
    //PATCH BUSINESS USING NETWORK
    static func editBusiness(url:String,
                         filter:String,
                         header: [String: String],
                         jsonData: Data,
                         showLoader: Bool,
                         successCompletion: @escaping (TransactionsNetworkData)->Void,
                         failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.PATCH(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.TRANSACTIONSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let transactionsModel = try JSONDecoder().decode(TransactionsNetworkData.self, from: response as! Data)
                dataModel = transactionsModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END PATCH BUSINESS NETWORK
    
     
}
