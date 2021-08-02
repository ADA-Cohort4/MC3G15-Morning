//
//  InviteeLinksAPIRequest.swift
//  Rekord
//
//  Created by Julius Cesario on 01/08/21.
//

import Foundation

class InviteLinksAPIRequest: NSObject{
    
    //GET INVITELINK METHOD USING NETWORK
    static func getInviteLinks(url:String,
                             filter:String,
                             header: [String: String],
                             showLoader: Bool,
                             successCompletion: @escaping (InviteLinksNetworkData)->Void,
                             failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.GET(url: url, filter: filter, header: header, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.INVITELINKSNETWROKDATA
            
            // handle the response and parsing the data to data model
            do {
                let inviteLinkModel = try JSONDecoder().decode(InviteLinksNetworkData.self, from: response as! Data)
                dataModel = inviteLinkModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END GET INVITELINK NETWORK
    
    //CREATE INVITELINK USING NETWORK
    static func createInviteLink(url:String,
                           filter:String,
                           header: [String: String],
                           jsonData: Data,
                           showLoader: Bool,
                           successCompletion: @escaping (InviteLinksNetworkData)->Void,
                           failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.POST(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.INVITELINKSNETWROKDATA
            
            // handle the response and parsing the data to data model
            do {
                let inviteLinkModel = try JSONDecoder().decode(InviteLinksNetworkData.self, from: response as! Data)
                dataModel = inviteLinkModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END CREATE INVITELINK NETWORK
    
    //PATCH INVITELINK USING NETWORK
    static func editInviteLink(url:String,
                         filter:String,
                         header: [String: String],
                         jsonData: Data,
                         showLoader: Bool,
                         successCompletion: @escaping (InviteLinksNetworkData)->Void,
                         failCompletion:@escaping (String)-> Void) {
        // create request
        BaseRequest.PATCH(url: url, filter: filter, header: header, jsonData: jsonData, showLoader: showLoader) { response in
            print(response)
            // prepare the data model
            var dataModel = DataManager.INVITELINKSNETWROKDATA
            
            // handle the response and parsing the data to data model
            do {
                let inviteLinkModel = try JSONDecoder().decode(InviteLinksNetworkData.self, from: response as! Data)
                dataModel = inviteLinkModel
                successCompletion(dataModel!)
            } catch let error { //handle error
                print("error reading json file content: \(error.localizedDescription)")
            }
        }
    }
    //END PATCH INVITELINK NETWORK
    
     
}
