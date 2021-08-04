//
//  PaymentRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//
import UIKit
import CoreData

class PaymentRepository {
    static let share = PaymentRepository()
    
    private init() {}
    
    func savePayment(payment: PaymentModel, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let paymentEntity = NSEntityDescription.entity(forEntityName: "Payment", in: managedContext)!
        let paymentData = NSManagedObject(entity: paymentEntity, insertInto: managedContext)
        paymentData.setValue(payment.idPayment, forKey: "id_payment")
        paymentData.setValue(payment.idTransaction, forKey: "id_transaction")
        paymentData.setValue(payment.idUser, forKey: "id_user")
        paymentData.setValue(payment.createdDate, forKey: "created_date")
        paymentData.setValue(payment.amount, forKey: "amount")
        paymentData.setValue(payment.document, forKey: "document")
        paymentData.setValue(payment.airtableId, forKey: "airtable_id")
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed save business = \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updatePayment(payment: PaymentModel, completion: @escaping (_ status: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "id_payment = %@", payment.idPayment!)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            data.setValue(payment.amount, forKeyPath: "amount")
            try managedContext.save()
            completion(true)
        }catch let err {
            print("err = \(err.localizedDescription)")
            completion(false)
        }
    }
    
    func getPayment(completion: @escaping(_ idPayment: String) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Payment")
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            completion(data.value(forKey: "id_payment") as! String)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            completion("")
        }
    }
    
    func getAllPayment(completion: @escaping(_ listPayment: [PaymentModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Payment")
        do {
            var listPayment: [PaymentModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (payment) in
                listPayment.append(PaymentModel(
                idPayment: payment.value(forKey: "id_payment") as! String,
                idTransaction: payment.value(forKey: "id_payment") as! String,
                idUser: payment.value(forKey: "id_user") as! String,
                createdDate: payment.value(forKey: "created_date") as! String,
                amount: payment.value(forKey: "amount") as! String,
                document: payment.value(forKey: "document") as! String,
                airtableId: payment.value(forKey: "document") as! String))
            }
            completion(listPayment, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
    
}
