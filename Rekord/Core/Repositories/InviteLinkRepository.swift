//
//  InviteLinkRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//

import UIKit
import CoreData

class InviteLinkRepository {
    static let share = InviteLinkRepository()
    
    private init() {}
    
    func saveInviteLink(inviteLink: InviteLinkModel, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let inviteLinkEntity = NSEntityDescription.entity(forEntityName: "InviteLink", in: managedContext)!
        let inviteLinkData = NSManagedObject(entity: inviteLinkEntity, insertInto: managedContext)
        inviteLinkData.setValue(inviteLink.idInviteLink, forKey: "id_invitelink")
        inviteLinkData.setValue(inviteLink.idUser, forKey: "id_user")
        inviteLinkData.setValue(inviteLink.idRecepient, forKey: "id_recepient")
        inviteLinkData.setValue(inviteLink.status, forKey: "status")
        inviteLinkData.setValue(inviteLink.createdDate, forKey: "created_date")
        inviteLinkData.setValue(inviteLink.airtableId, forKey: "airtable_id")
        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed save InviteLink = \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateInviteLink(inviteLink : InviteLinkModel, completion: @escaping (_ status: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "InviteLink")
        fetchRequest.predicate = NSPredicate(format: "id_invitelink = %@", inviteLink.idInviteLink!)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            data.setValue(inviteLink.status, forKeyPath: "status")
            try managedContext.save()
            completion(true)
        }catch let err {
            print("err = \(err.localizedDescription)")
            completion(false)
        }
    }
    
    func getInviteLink(completion: @escaping(_ idInviteLink: String) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "InviteLink")
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            completion(data.value(forKey: "status") as! String)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            completion("")
        }
    }
    
    func getAllInviteLink(completion: @escaping(_ listInviteLink: [InviteLinkModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
        do {
            var listInviteLink: [InviteLinkModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (inviteLink) in
                listInviteLink.append(InviteLinkModel(idInviteLink: inviteLink.value(forKey: "id_inviteLink") as! String, idUser: inviteLink.value(forKey: "id_user") as! String, idRecepient: inviteLink.value(forKey: "id_recipient") as! String, status: inviteLink.value(forKey: "status") as! InvitationActivationStatus, createdDate: inviteLink.value(forKey: "created_date") as! String, airtableId: inviteLink.value(forKey: "airtable_id") as! String))
            }
            completion(listInviteLink, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
