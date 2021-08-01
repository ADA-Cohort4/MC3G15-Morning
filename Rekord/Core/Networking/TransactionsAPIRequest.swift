//
//  TransactionsAPIRequest.swift
//  Rekord
//
//  Created by Julius Cesario on 01/08/21.
//

import Foundation

class TransactionsAPIRequest: NSObject{
    
    //GET TRANSACTION METHOD USING NETWORK
    static func getTransactionsData(url:String,
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
    //END GET TRANSACTION NETWORK
    
    //CREATE TRANSACTION USING NETWORK
    static func createTransaction(url:String,
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
    //END CREATE TRANSACTION NETWORK
    
    //PATCH TRANSACTION USING NETWORK
    static func editTransaction(url:String,
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
    //END PATCH TRANSACTION NETWORK
    
     
}
