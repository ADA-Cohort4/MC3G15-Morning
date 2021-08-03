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
        userData.setValue(user.role, forKeyPath: "role")
        userData.setValue(user.email, forKeyPath: "email")
        userData.setValue(user.profileUrl, forKeyPath: "profile_url")
        
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
    
}
