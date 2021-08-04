//
//  UserRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

import UIKit
import CoreData

class UserRepository {
    static let share = UserRepository()
    
    private init() {}
    
    func saveUser(user: UserModel, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let userData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        userData.setValue(user.idUser, forKeyPath: "id_user")
        userData.setValue(user.appleId, forKeyPath: "apple_id")
        userData.setValue(user.passcode, forKeyPath: "passcode")
        userData.setValue(user.role?.rawValue, forKeyPath: "role")
        userData.setValue(user.email, forKeyPath: "email")
        userData.setValue(user.profileUrl, forKeyPath: "profile_url")
        userData.setValue(user.phone, forKeyPath: "phone")
        userData.setValue(user.airtableId, forKeyPath: "airtable_id")
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed save user = \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateUser(user: UserModel, completion: @escaping (_ status: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id_user = %@", user.idUser!)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            data.setValue(user.email, forKeyPath: "email")
            try managedContext.save()
            completion(true)
        }catch let err {
            print("err = \(err.localizedDescription)")
            completion(false)
        }
    }
    
    func getUser(completion: @escaping(_ email: String, _ passcode: String) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            completion(data.value(forKey: "email") as! String, data.value(forKey: "passcode") as! String)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            completion("", "")
        }
    }
    
    func getAllUsers(completion: @escaping(_ users: [UserModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        do {
            var users: [UserModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (user) in
                users.append(UserModel(
                    idUser: user.value(forKey: "id_user") as! String,
                    appleId: user.value(forKey: "apple_id") as! String,
                    passcode: user.value(forKey: "passcode") as! String,
                    role: user.value(forKey: "role") as! RoleType,
                    email: user.value(forKey: "email") as! String,
                    profileUrl: user.value(forKey: "profile_url") as! String,
                    phone: user.value(forKey: "phone") as! String,
                    airtableId: user.value(forKey: "airtable_id") as! String))
            }
            completion(users, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
