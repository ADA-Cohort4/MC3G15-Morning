//
//  PartnerRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//

import UIKit
import CoreData

class PartnerRepository {
    // prepare json data
    var jsonData: Data?

    // variable to store the data response that will be displayed
    var partnerNetworkModel: PartnersNetworkData?
    
    static let shared = PartnerRepository()
    
    private init() {}
    
    //SAVE NEW PARTNER
    func savePartner(partner: PartnerModel, completion: @escaping (PartnerModel) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "fields" : [
                    "id_partner": partner.idPartner!,
                    "id_user": partner.idUser!,
                    "id_business": partner.idBusiness!,
                    "name": partner.name!,
                    "phone": partner.phone!,
                    "type": partner.type!,
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
        let formula = "?filterByFormula=AND(id_business%3D%22\(String(describing: partner.idBusiness))%22%2Cphone%3D%22\(String(describing: partner.phone))%22)"
        
        // for filtering tabledata
        let filter = "Partners"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if business that want to be registered already exist or not
        PartnersAPIRequest.getPartnersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.partnerNetworkModel = response
            // check if user model not empty means data is exist
            if self.partnerNetworkModel?.records?.isEmpty == true{
                // post the data to API
                PartnersAPIRequest.createPartner(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                            let partnerEntity = NSEntityDescription.entity(forEntityName: "Partner", in: managedContext)!
                            let partnerData = NSManagedObject(entity: partnerEntity, insertInto: managedContext)
                            //VALUE SET CORE DATA TOBE SAVE
                            partnerData.setValue(response.records?.first?.fields?.id_partner, forKeyPath: "id_partner")
                            partnerData.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                            partnerData.setValue(response.records?.first?.fields?.id_business, forKeyPath: "id_business")
                            partnerData.setValue(response.records?.first?.fields?.name, forKeyPath: "name")
                            partnerData.setValue(response.records?.first?.fields?.phone, forKeyPath: "phone")
                            partnerData.setValue(response.records?.first?.fields?.status, forKeyPath: "status")
                            partnerData.setValue(response.records?.first?.fields?.type, forKeyPath: "type")
                            partnerData.setValue(response.records?.first?.id, forKeyPath: "airtable_id")
                            do {
                                try managedContext.save()
                                //SET USER CORE DATA TO CONTROLLER
                                partner.airtableId = response.records?.first?.id
                                partner.idUser = response.records?.first?.fields?.id_user
                                partner.idBusiness = response.records?.first?.fields?.id_business
                                partner.idPartner = response.records?.first?.fields?.id_partner
                                partner.type = PartnerType(rawValue: (response.records?.first?.fields?.status)!)
                                partner.name = response.records?.first?.fields?.name
                                partner.phone = response.records?.first?.fields?.phone
                                partner.status = PartnerActivationStatus(rawValue: (response.records?.first?.fields?.status)!)
                                completion(partner)
                            } catch let error {
                                print("failed save partner = \(error.localizedDescription)")
                                completion(partner)
                            }
                        }
                        //END SAVE CORE DATA
                    }else{
                        print("failed save user error on Airtable")
                        completion(partner)
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
    
    //UPDATE EXISTING PARTNER
    func updatePartner(partner: PartnerModel, completion: @escaping (_ status: Bool) -> ()) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : partner.airtableId!,
                "fields" : [
                    "user": partner.idUser!,
                    "name": partner.name!,
                    "phone": partner.phone!,
                    "type": partner.type?.rawValue,
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
        let formula = "?filterByFormula=AND(id_partner%3D%22\(partner.idPartner!)%22)"
        
        // for filtering tabledata
        let filter = "Users"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if users that want to be registered already exist or not
        PartnersAPIRequest.getPartnersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.partnerNetworkModel = response
            // check if user model not empty means data is exist
            if self.partnerNetworkModel?.records?.isEmpty == false{
                // post the data to API
                PartnersAPIRequest.editPartner(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Partner")
                            fetchRequest.predicate = NSPredicate(format: "id_partner = %@", partner.idPartner!)
                            //VALUE SET CORE DATA TOBE SAVE
                            do {
                                let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                                data.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                                data.setValue(response.records?.first?.fields?.name, forKeyPath: "name")
                                data.setValue(response.records?.first?.fields?.phone, forKeyPath: "phone")
                                data.setValue(response.records?.first?.fields?.type, forKeyPath: "type")
                                try managedContext.save()
                                completion(true)
                            }catch let err {
                                print("err = \(err.localizedDescription)")
                                completion(false)
                            }
                        }
                        //END SAVE CORE DATA
                    }else{
                        print("failed save partner error on Airtable")
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
    
    //DELETE EXISTING PARTNER
    func deletePartner(_ status:String, _ idPartner:String, _ airTableidPartner:String, completion: @escaping (_ status: Bool) -> ()) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : airTableidPartner,
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
        let filter = "Users"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        PartnersAPIRequest.editPartner(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Partner")
                    fetchRequest.predicate = NSPredicate(format: "id_partner = %@", idPartner)
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
    
    //GET PARTNER FROM CORE DATA
    func getPartner(completion: @escaping(PartnerModel) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Partner")
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            //SET USER CORE DATA TO CONTROLLER
            let partnerData = PartnerModel(
                idPartner: data.value(forKey: "id_partner") as! String,
                idUser: data.value(forKey: "id_user") as! String,
                idBusiness: data.value(forKey: "id_business") as! String,
                type:data.value(forKey: "type") as! PartnerType,
                name:data.value(forKey: "name") as! String,
                phone: data.value(forKey: "phone") as! String,
                status:data.value(forKey: "type") as! PartnerActivationStatus,
                airtableId: data.value(forKey: "airtable_id") as! String)
            completion(partnerData)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            let partnerData = PartnerModel(idPartner: "", idUser: "", idBusiness: "", type: PartnerType.customer, name:"", phone: "", status: PartnerActivationStatus.active, airtableId: "")
            completion(partnerData)
        }
    }
    
    //GET ALL PARTNER
    func getAllPartner(completion: @escaping(_ partnerList: [PartnerModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Partner")
        do {
            var partnerList: [PartnerModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (partner) in
                partnerList.append(PartnerModel(
                    idPartner: partner.value(forKey: "id_parner") as! String,
                    idUser: partner.value(forKey: "id_user") as! String,
                    idBusiness: partner.value(forKey: "id_business") as! String,
                    type: partner.value(forKey: "type") as! PartnerType,
                    name: partner.value(forKey: "name") as! String,
                    phone: partner.value(forKey: "phone") as! String,
                    status: partner.value(forKey: "status") as! PartnerActivationStatus,
                    airtableId: partner.value(forKey: "airtable_id") as! String))
            }
            completion(partnerList, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
