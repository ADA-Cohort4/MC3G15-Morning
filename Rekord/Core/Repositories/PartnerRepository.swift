//
//  PartnerRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//

import UIKit
import CoreData

class PartnerRepository {
    static let share = PartnerRepository()
    
    private init() {}
    
    func saveParner(partner: PartnerModel, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let partnerEntity = NSEntityDescription.entity(forEntityName: "Partner", in: managedContext)!
        let partnerData = NSManagedObject(entity: partnerEntity, insertInto: managedContext)
        partnerData.setValue(partner.idPartner, forKeyPath: "id_partner")
        partnerData.setValue(partner.idUser, forKeyPath: "id_user")
        partnerData.setValue(partner.type?.rawValue, forKeyPath: "type")
        partnerData.setValue(partner.phone, forKeyPath: "phone")
        partnerData.setValue(partner.status, forKeyPath: "status")
        partnerData.setValue(partner.airtableId, forKeyPath: "airtable_id")
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed save user = \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateUser(partner: PartnerModel, completion: @escaping (_ status: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Partner")
        fetchRequest.predicate = NSPredicate(format: "id_partner = %@", partner.idPartner!)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            data.setValue(partner.type?.rawValue, forKeyPath: "type")
            try managedContext.save()
            completion(true)
        }catch let err {
            print("err = \(err.localizedDescription)")
            completion(false)
        }
    }
    
    func getPartner(completion: @escaping(_ idPartner: String) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Partner")
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            completion(data.value(forKey: "email") as! String)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            completion("")
        }
    }
    
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
                    type: partner.value(forKey: "typer") as! PartnerType,
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
