//
//  BusinessRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//

import UIKit
import CoreData

class BusinessRepository {
    static let share = BusinessRepository()
    
    private init() {}
    
    func saveBusiness(business: BusinessModel, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Business", in: managedContext)!
        let userData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        userData.setValue(business.idBusiness, forKeyPath: "id_business")
        userData.setValue(business.idUser, forKeyPath: "id_user")
        userData.setValue(business.name, forKeyPath: "name")
        userData.setValue(business.email, forKeyPath: "email")
        userData.setValue(business.phone, forKeyPath: "phone")
        userData.setValue(business.address, forKeyPath: "address")
        userData.setValue(business.airtableId, forKeyPath: "airtable_id")
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed save business = \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateBusiness(business: BusinessModel, completion: @escaping (_ status: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
        fetchRequest.predicate = NSPredicate(format: "id_business = %@", business.idBusiness!)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            data.setValue(business.name, forKeyPath: "name")
            try managedContext.save()
            completion(true)
        }catch let err {
            print("err = \(err.localizedDescription)")
            completion(false)
        }
    }
    
    func getBusiness(completion: @escaping(_ idBusiness: String) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            completion(data.value(forKey: "id_business") as! String)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            completion("")
        }
    }

    func getAllBusiness(completion: @escaping(_ listBusiness: [BusinessModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
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
                    airtableId: business.value(forKey: "airtable_id") as! String))
            }
            completion(listBusiness, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
