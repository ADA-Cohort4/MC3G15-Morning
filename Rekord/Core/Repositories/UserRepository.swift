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
}
