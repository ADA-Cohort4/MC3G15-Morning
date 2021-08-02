//
//  APIRequest.swift
//  Rekord
//
//  Created by Julius Cesario on 30/07/21.
//

import Foundation

class PartnersAPIRequest: NSObject{
    
    //GET PARTNER METHOD USING NETWORK
    static func getPartnersData(url:String,
                             filter:String,
                             header: [String: String],
                             showLoader: Bool,
                             successCompletion: @escaping (PartnersNetworkData)->Void,
                             failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.GET(url: url, filter: filter, header: header, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.PARTNERSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let partnersModel = try JSONDecoder().decode(PartnersNetworkData.self, from: response as! Data)
                dataModel = partnersModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END GET PARTNER NETWORK
    
    //CREATE PARTNER USING NETWORK
    static func createPartner(url:String,
                           filter:String,
                           header: [String: String],
                           jsonData: Data,
                           showLoader: Bool,
                           successCompletion: @escaping (PartnersNetworkData)->Void,
                           failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.POST(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.PARTNERSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let partnersModel = try JSONDecoder().decode(PartnersNetworkData.self, from: response as! Data)
                dataModel = partnersModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END CREATE PARTNER NETWORK
    
    //PATCH PARTNER USING NETWORK
    static func editPartner(url:String,
                         filter:String,
                         header: [String: String],
                         jsonData: Data,
                         showLoader: Bool,
                         successCompletion: @escaping (PartnersNetworkData)->Void,
                         failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.PATCH(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.PARTNERSNETWORKDATA
            
            // handle the response and parsing the data to data model
            do {
                let partnersModel = try JSONDecoder().decode(PartnersNetworkData.self, from: response as! Data)
                dataModel = partnersModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END PATCH PARTNER NETWORK
    
     
}
