//
//  PaymentsAPIRequest.swift
//  Rekord
//
//  Created by Julius Cesario on 01/08/21.
//

import Foundation

class PaymentsAPIRequest: NSObject{
    
    //GET PAYMENTS METHOD USING NETWORK
    static func getPayments(url:String,
                             filter:String,
                             header: [String: String],
                             showLoader: Bool,
                             successCompletion: @escaping (PaymentsNetworkData)->Void,
                             failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.GET(url: url, filter: filter, header: header, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.PAYMENTSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let paymentsModel = try JSONDecoder().decode(PaymentsNetworkData.self, from: response as! Data)
                dataModel = paymentsModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END GET PAYMENTS NETWORK
    
    //CREATE PAYMENTS USING NETWORK
    static func createPayment(url:String,
                           filter:String,
                           header: [String: String],
                           jsonData: Data,
                           showLoader: Bool,
                           successCompletion: @escaping (PaymentsNetworkData)->Void,
                           failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.POST(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.PAYMENTSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let paymentsModel = try JSONDecoder().decode(PaymentsNetworkData.self, from: response as! Data)
                dataModel = paymentsModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END CREATE PAYMENTS NETWORK
    
    //PATCH PAYMENTS USING NETWORK
    static func editPayment(url:String,
                         filter:String,
                         header: [String: String],
                         jsonData: Data,
                         showLoader: Bool,
                         successCompletion: @escaping (PaymentsNetworkData)->Void,
                         failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.PATCH(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.PAYMENTSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let paymentsModel = try JSONDecoder().decode(PaymentsNetworkData.self, from: response as! Data)
                dataModel = paymentsModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END PATCH PAYMENTS NETWORK
    
     
}
