//
//  BusinessRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//

import UIKit
import CoreData

class BusinessRepository {
    // prepare json data
    var jsonData: Data?

    // variable to store the data response that will be displayed
    var businessNetworkModel: BusinessNetworkData?
    
    static let shared = BusinessRepository()
    
    private init() {}
    
    //SAVE NEW BUSINESS AFTER SAVE USER
    func saveBusiness(business: BusinessModel, completion: @escaping (BusinessModel) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "fields" : [
                    "id_business": business.idBusiness!,
                    "id_user": business.idUser!,
                    "name": business.name!,
                    "email": business.email!,
                    "phone": business.phone ?? "",
                    "address": business.address ?? "",
                    "status": "active"
                ]
            ]]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //for getting method spesific data
        let formula = "?filterByFormula=AND(id_user%3D%22\(business.idUser!)%22)"
        
        // for filtering tabledata
        let filter = "Businesses"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if business that want to be registered already exist or not
        BusinessAPIRequest.getBusinessesData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.businessNetworkModel = response
            // check if user model not empty means data is exist
            if self.businessNetworkModel?.records?.isEmpty == true{
                // post the data to API
                BusinessAPIRequest.createBusiness(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
                    //handle if success
                    //Checking response
                    if(response.records?.isEmpty == false){
                        //SAVE CORE DATA
                        DispatchQueue.main.async {
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                                print("app delegate nil")
                                return
                            }
                            let managedContext = appDelegate.persistentContainer.viewContext
                            let businessEntity = NSEntityDescription.entity(forEntityName: "Business", in: managedContext)!
                            let businessData = NSManagedObject(entity: businessEntity, insertInto: managedContext)
                            //VALUE SET CORE DATA TOBE SAVE
                            businessData.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                            businessData.setValue(response.records?.first?.fields?.id_business, forKeyPath: "id_business")
                           businessData.setValue(response.records?.first?.fields?.address, forKeyPath: "address")
                            businessData.setValue(response.records?.first?.fields?.email, forKeyPath: "email")
                            businessData.setValue(response.records?.first?.fields?.status, forKeyPath: "status")
                            businessData.setValue(response.records?.first?.fields?.phone, forKeyPath: "phone")
                            businessData.setValue(response.records?.first?.fields?.name, forKeyPath: "name")
                            businessData.setValue(response.records?.first?.id, forKeyPath: "airtable_id")
                            do {
                                try managedContext.save()
                                //SET USER CORE DATA TO CONTROLLER
                                business.airtableId = response.records?.first?.id
                                business.idUser = response.records?.first?.fields?.id_user
                                business.idBusiness = response.records?.first?.fields?.id_business
                               business.address = response.records?.first?.fields?.address
                                business.name = response.records?.first?.fields?.name
                                business.phone = response.records?.first?.fields?.phone
                                business.email = response.records?.first?.fields?.email
                                business.status = response.records?.first?.fields?.status
                                completion(business)
                            } catch let error {
                                print("failed save user = \(error.localizedDescription)")
                                completion(business)
                            }
                        }
                        //END SAVE CORE DATA
                    }else{
                        print("failed save user error on Airtable")
                        completion(business)
                    }
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
    
    //UPDATE EXISTING BUSINESS
    func updateBusiness(business: BusinessModel, completion: @escaping (_ status: Bool) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : business.airtableId!,
                "fields" : [
                    "id_business": business.idBusiness!,
                    "id_user": business.idUser!,
                    "name": business.name!,
                    "email": business.email!,
                    "phone": business.phone ?? "",
                    "address": business.address ?? "",
                    "status": "active",
                    "airtable_id": business.airtableId!
                ]
            ]]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //for getting method spesific data
        let formula = "?filterByFormula=AND(id_user%3D%22\(business.idUser!)%22)"
        
        // for filtering tabledata
        let filter = "Businesses"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if business that want to be updated already exist or not
        BusinessAPIRequest.getBusinessesData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.businessNetworkModel = response
            // check if user model not empty means data is exist
            if self.businessNetworkModel?.records?.isEmpty == false{
                // post the data to API
                BusinessAPIRequest.editBusiness(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
                    //handle if success
                    //Checking response
                    if(response.records?.isEmpty == false){
                        //SAVE CORE DATA
                        DispatchQueue.main.async {
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                                print("app delegate nil")
                                return
                            }
                            let managedContext = appDelegate.persistentContainer.viewContext
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
                            fetchRequest.predicate = NSPredicate(format: "id_business = %@", business.idBusiness!)
                            //VALUE SET CORE DATA TOBE SAVE
                            do {
                                let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                                data.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                                data.setValue(response.records?.first?.fields?.id_business, forKeyPath: "id_business")
                                data.setValue(response.records?.first?.fields?.email, forKeyPath: "email")
                                data.setValue(response.records?.first?.fields?.name, forKeyPath: "name")
                              data.setValue(response.records?.first?.fields?.address, forKeyPath: "address")
                                data.setValue(response.records?.first?.fields?.status, forKeyPath: "status")
                                data.setValue(response.records?.first?.id, forKeyPath: "airtable_id")
                                try managedContext.save()
                                completion(true)
                            }catch let err {
                                print("err = \(err.localizedDescription)")
                                completion(false)
                            }
                        }
                        //END SAVE CORE DATA
                    }else{
                        print("failed save business error on Airtable")
                        completion(true)
                    }
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
    
    //DELETE EXISTING USER
    func deleteBusiness(_ status:String, _ idBusiness:String, _ airTableidBusiness:String, completion: @escaping (_ status: Bool) -> ()) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : airTableidBusiness,
                "fields" : [
                    "status": status,
                ]
            ]]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        // for filtering tabledata
        let filter = "Business"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        BusinessAPIRequest.editBusiness(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
            //handle if success
            //Checking response
            if(response.records?.isEmpty == false){
                //SAVE CORE DATA
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        print("app delegate nil")
                        return
                    }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
                    fetchRequest.predicate = NSPredicate(format: "id_user = %@", idBusiness)
                    do {
                        let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                        data.setValue("inactive", forKeyPath: "status")
                        try managedContext.save()
                        completion(true)
                    }catch let err {
                        print("err = \(err.localizedDescription)")
                        completion(false)
                    }
                    //VALUE SET CORE DATA TOBE SAVE
                    
                    do {
                        try managedContext.save()
                        //SET USER CORE DATA TO CONTROLLER
                        completion(true)
                    } catch let error {
                        print("failed save user = \(error.localizedDescription)")
                        completion(true)
                    }
                }
                //END SAVE CORE DATA
            }else{
                print("failed save user error on Airtable")
                completion(true)
            }
        } failCompletion: { message in
            //handle of failure
            //display alert failure
            //dismiss
            print(message)
        }
    }
    
    //GET BUSINESS BY BY ID BUSINESS
    func getBusiness(_ idUser: String, completion: @escaping(BusinessModel) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
        fetchRequest.predicate = NSPredicate(format: "id_user = %@", idUser)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            //SET USER CORE DATA TO CONTROLLER
            let businessData = BusinessModel(
                idBusiness: data.value(forKey: "id_business") as! String,
                idUser: data.value(forKey: "id_user") as! String,
                name:data.value(forKey: "name") as! String,
                email: data.value(forKey: "email") as! String,
                phone: data.value(forKey: "phone") as! String,
                address: data.value(forKey: "address") as! String,
                airtableId: data.value(forKey: "airtable_id") as! String,
                status: data.value(forKey: "status") as! String)
            completion(businessData)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            let businessData = BusinessModel(idBusiness: "", idUser: "", name: "", email: "", phone: "", address: "", airtableId: "", status: "")
            completion(businessData)
        }
    }
    
    //GET ALL BUSINESS ON RELATE USER ID
    func getAllBusiness(_ idUser:String, completion: @escaping(_ listBusiness: [BusinessModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
        fetchRequest.predicate = NSPredicate(format: "id_user = %@ && status = %@", idUser, "active")
        do {
            var listBusiness: [BusinessModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (business) in
                listBusiness.append(BusinessModel(
                    idBusiness: business.value(forKey: "id_business") as! String,
                    idUser: business.value(forKey: "id_user") as! String,
                    name: business.value(forKey: "name") as! String,
                    email: business.value(forKey: "email") as! String,
                    phone: business.value(forKey: "phone") as! String,
                    address: business.value(forKey: "address") as! String,
                    airtableId: business.value(forKey: "airtable_id") as! String,
                    status: business.value(forKey: "status") as! String
                ))
            }
            completion(listBusiness, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
