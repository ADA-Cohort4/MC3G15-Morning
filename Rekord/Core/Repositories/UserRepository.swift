//
//  UserRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

import UIKit
import CoreData

class UserRepository {
    // prepare json data
    var jsonData: Data?

    // variable to store the data response that will be displayed
    var userModel: UsersNetworkData?
    
    static let shared = UserRepository()
    
    private init() {}

    //SAVE NEW USER
    func saveUser(user: UserModel, completion: @escaping (UserModel) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "fields" : [
                    "id_user": user.idUser!,
                    "id_business": user.idBusiness,
                    "apple_id": user.appleId!,
                    "passcode": user.passcode!,
                    "role": user.role?.rawValue,
                    "email": user.email!,
                    "phone": user.phone ?? "",
                    "profile_url": user.profileUrl ?? "",
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
        let formula = "?filterByFormula=AND(email%3D%22\(user.email!)%22)"
        
        // for filtering tabledata
        let filter = "Users"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if users that want to be registered already exist or not
        UsersAPIRequest.getUsersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.userModel = response
            // check if user model not empty means data is exist
            if self.userModel?.records?.isEmpty == true{
                // post the data to API
                UsersAPIRequest.createUser(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                            let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                            let userData = NSManagedObject(entity: userEntity, insertInto: managedContext)
                            //VALUE SET CORE DATA TOBE SAVE
                            userData.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                            userData.setValue(response.records?.first?.fields?.apple_id, forKeyPath: "apple_id")
                            userData.setValue(response.records?.first?.fields?.id_business, forKeyPath: "id_business")
                            userData.setValue(response.records?.first?.fields?.passcode, forKeyPath: "passcode")
                            userData.setValue(response.records?.first?.fields?.role, forKeyPath: "role")
                            userData.setValue(response.records?.first?.fields?.id_user, forKeyPath: "email")
                            userData.setValue(response.records?.first?.fields?.profile_url, forKeyPath: "profile_url")
                            userData.setValue(response.records?.first?.id, forKeyPath: "airtable_id")
                            do {
                                try managedContext.save()
                                //SET USER CORE DATA TO CONTROLLER
                                user.airtableId = response.records?.first?.id
                                user.idUser = response.records?.first?.fields?.id_user
                                user.idBusiness = response.records?.first?.fields?.id_business
                                user.appleId = response.records?.first?.fields?.apple_id
                                user.passcode = response.records?.first?.fields?.passcode
                                user.role = RoleType(rawValue: (response.records?.first?.fields?.role)!)
                                user.profileUrl = response.records?.first?.fields?.profile_url
                                user.email = response.records?.first?.fields?.email
                                completion(user)
                            } catch let error {
                                print("failed save user = \(error.localizedDescription)")
                                completion(user)
                            }
                        }
                        //END SAVE CORE DATA
                    }else{
                        print("failed save user error on Airtable")
                        completion(user)
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
    
    //UPDATE EXISTING USER
    func updateUser(user: UserModel, completion: @escaping (_ status: Bool) -> ()) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : user.airtableId!,
                "fields" : [
                    "id_user": user.idUser!,
                    "id_business": user.idBusiness!,
                    "apple_id": user.appleId!,
                    "passcode": user.passcode!,
                    "role": user.role?.rawValue,
                    "email": user.email!,
                    "phone": user.phone ?? "",
                    "profile_url": user.profileUrl ?? ""
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
        let formula = "?filterByFormula=AND(email%3D%22\(user.email!)%22)"
        
        // for filtering tabledata
        let filter = "Users"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if users that want to be registered already exist or not
        UsersAPIRequest.getUsersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.userModel = response
            // check if user model not empty means data is exist
            if self.userModel?.records?.isEmpty == false{
                // post the data to API
                UsersAPIRequest.editUser(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
                            fetchRequest.predicate = NSPredicate(format: "id_user = %@", user.idUser!)
                            //VALUE SET CORE DATA TOBE SAVE
                            do {
                                let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                                data.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                                data.setValue(response.records?.first?.fields?.id_business, forKeyPath: "id_business")
                                data.setValue(response.records?.first?.fields?.apple_id, forKeyPath: "apple_id")
                                data.setValue(response.records?.first?.fields?.passcode, forKeyPath: "passcode")
                                data.setValue(response.records?.first?.fields?.role, forKeyPath: "role")
                                data.setValue(response.records?.first?.fields?.id_user, forKeyPath: "email")
                                data.setValue(response.records?.first?.fields?.profile_url, forKeyPath: "profile_url")
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
        } failCompletion: { message in
            // display alert failure
            // dismiss loader
            print(message)
        }
    }
    
    //DELETE EXISTING USER
    func deleteUser(_ status:String, _ idUser:String, _ airTableidUser:String, completion: @escaping (_ status: Bool) -> ()) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : airTableidUser,
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
        
        UsersAPIRequest.editUser(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
                    fetchRequest.predicate = NSPredicate(format: "id_user = %@", idUser)
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
    
    //LOGIN USER
    func loginUser(_ appleId: String, _ passcode: String, completion: @escaping(_ idUser: String) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "apple_id = %@ && passcode = %@", appleId, passcode)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            completion(data.value(forKey: "id_user") as! String)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            completion("")
        }
    }
    
    //GET USER BY ID USER
    func getUser(_ idUser: String, completion: @escaping(UserModel) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id_user = %@", idUser)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            //SET USER CORE DATA TO CONTROLLER
            let userData = UserModel(
                idUser: data.value(forKey: "id_user") as! String,
                idBusiness: data.value(forKey: "id_business") as! String,
                appleId: data.value(forKey: "apple_id") as! String,
                passcode: "",
                role:data.value(forKey: "role") as! RoleType,
                email: data.value(forKey: "email") as! String,
                profileUrl: data.value(forKey: "profile_url") as! String,
                phone: data.value(forKey: "phone") as! String,
                airtableId: data.value(forKey: "airtable_id") as! String,
                status: data.value(forKey: "status") as! String)
            completion(userData)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            let userData = UserModel(idUser: "", idBusiness: "", appleId: "", passcode: "", role: RoleType(rawValue: "owner") ?? RoleType.owner, email: "", profileUrl: "", phone: "", airtableId: "", status: "")
            completion(userData)
        }
    }
    
    
    //BY APPLE ID
    func getUserByAppleId(_ appleId: String, completion: @escaping(UserModel) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "apple_id = %@", appleId)
        do {
//            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
//            //SET USER CORE DATA TO CONTROLLER
//            let userData = UserModel(
//                idUser: data.value(forKey: "id_user") as! String,
//                appleId: data.value(forKey: "apple_id") as! String,
//                passcode: "",
//                role:data.value(forKey: "role") as! RoleType,
//                email: data.value(forKey: "email")f as! String,
//                profileUrl: data.value(forKey: "profile_url") as! String,
//                phone: data.value(forKey: "phone") as! String,
//                airtableId: data.value(forKey: "airtable_id") as! String,
//                status: data.value(forKey: "status") as! String)
//            completion(userData)
            let fetchRequestAppleId = try managedContext.fetch(fetchRequest)
            if (fetchRequestAppleId.count > 0 ) {
                let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                let userData = UserModel(
                    idUser: data.value(forKey: "id_user") as! String,
                    idBusiness: data.value(forKey: "id_business") as! String,
                    appleId: data.value(forKey: "apple_id") as! String,
                    passcode: "",
                    role: .owner,
                    email: data.value(forKey: "email") as! String,
                    profileUrl: "",
                    phone: "",
                    airtableId: data.value(forKey: "airtable_id") as! String,
                    status: "")
                completion(userData)
            }else{
                let nullUserData = UserModel(idUser: "", idBusiness: "", appleId: "", passcode: "", role: RoleType(rawValue: "owner") ?? RoleType.owner, email: "", profileUrl: "", phone: "", airtableId: "", status: "")
                completion(nullUserData)
            }
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            let userData = UserModel(idUser: "", idBusiness: "", appleId: "", passcode: "", role: RoleType(rawValue: "owner") ?? RoleType.owner, email: "", profileUrl: "", phone: "", airtableId: "", status: "")
            completion(userData)
        }
    }
    
    //GET ALL USERS
    func getAllUsers(completion: @escaping(_ users: [UserModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "status = %@", "active")
        do {
            var users: [UserModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (user) in
                users.append(UserModel(
                    idUser: user.value(forKey: "id_user") as! String,
                    idBusiness: user.value(forKey: "id_business") as! String,
                    appleId: user.value(forKey: "apple_id") as! String,
                    passcode: user.value(forKey: "passcode") as! String,
                    role: user.value(forKey: "role") as! RoleType,
                    email: user.value(forKey: "email") as! String,
                    profileUrl: user.value(forKey: "profile_url") as! String,
                    phone: user.value(forKey: "phone") as! String,
                    airtableId: user.value(forKey: "airtable_id") as! String,
                    status: user.value(forKey: "status") as! String))
            }
            completion(users, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
