//
//  BaseRequest.swift
//  Rekord
//
//  Created by Julius Cesario//

import Foundation

class BaseRequest: NSObject {
    //GET FUNCTION
    static func GET(url: String,
                    filter:String,
                    header: [String:String],
                    showLoader: Bool,
                    completionHandler: @escaping (Any) -> Void) {
        
        if showLoader {
            //display loader
        }
        //newURL add new url and filter
        var newurl:String = ""
        //Logic filter on Rekord
        if filter.isEmpty == false{
            newurl = url+filter
        }else{
            newurl = url
        }
        //init request
        let request = NSMutableURLRequest(url: NSURL(string: newurl)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        //configure request and set header
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = header
        
        //init session
        let session = URLSession.shared
        
        //init datatask
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let dataFromAPI = data {
                    completionHandler(dataFromAPI)
                }
            }
        })
        
        dataTask.resume()
    }
    //END OF GET FUNCTION
    
    //POST FUNCTION
    static func POST(url: String,
                     filter: String,
                     header: [String:String],
                     jsonData: Data,
                     showLoader: Bool,
                     completionHandler: @escaping (Any) -> Void) {
        
        if showLoader {
            //display loader
        }
        
        //newURL add new url and filter
        var newurl:String = ""
        //Logic filter on Rekord
        if filter.isEmpty == false{
            newurl = url+filter
        }else{
            newurl = url
        }
        
        //init request
        let request = NSMutableURLRequest(url: NSURL(string: newurl)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        //configure request and set header
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = header
        // Set HTTP Request Headers
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set HTTP Request Body
        request.httpBody = jsonData;
        
        //init session
        let session = URLSession.shared
        
        //init datatask
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let dataFromAPI = data {
                    completionHandler(dataFromAPI)
                }
            }
        })
        
        dataTask.resume()
    }
    //END OF POST FUNCTION
    
    //PATCH FUNCTION
    static func PATCH(url: String,
                     filter: String,
                     header: [String:String],
                     jsonData: Data,
                     showLoader: Bool,
                     completionHandler: @escaping (Any) -> Void) {
        
        if showLoader {
            //display loader
        }
        
        //newURL add new url and filter
        var newurl:String = ""
        //Logic filter on Rekord
        if filter.isEmpty == false{
            newurl = url+filter
        }else{
            newurl = url
        }
        
        //init request
        let request = NSMutableURLRequest(url: NSURL(string: newurl)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        //configure request and set header
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = header
        // Set HTTP Request Headers
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set HTTP Request Body
        request.httpBody = jsonData;
        
        //init session
        let session = URLSession.shared
        
        //init datatask
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let dataFromAPI = data {
                    completionHandler(dataFromAPI)
                }
            }
        })
        
        dataTask.resume()
    }
    //END OF PATCH FUNCTION
}
