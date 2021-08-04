//
//  TransactionRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 02/08/21.
//
import UIKit
import CoreData

class TransactionRepository {
    static let shared = TransactionRepository()
    
    private init() {}
    
    func saveTransaction(transaction: TransactionModel, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let transactionEntity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
        let transactionData = NSManagedObject(entity: transactionEntity, insertInto: managedContext)
        transactionData.setValue(transaction.idTransaction, forKeyPath: "id_transaction")
        transactionData.setValue(transaction.idPartner, forKeyPath: "id_partner")
        transactionData.setValue(transaction.totalPrice, forKeyPath: "total_price")
        transactionData.setValue(transaction.paymentCount, forKeyPath: "payment_count")
        transactionData.setValue(transaction.document, forKeyPath: "document")
        transactionData.setValue(transaction.dueDate, forKeyPath: "due_date")
        transactionData.setValue(transaction.createdDate, forKeyPath: "created_date")
        transactionData.setValue(transaction.updatedDate, forKeyPath: "updated_date")
        transactionData.setValue(transaction.status?.rawValue, forKeyPath: "status")
        transactionData.setValue(transaction.airtableId, forKeyPath: "airtable_id")
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed save user = \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func checkTransactionId(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return false
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Transaction")
        fetchRequest.predicate = NSPredicate(format: "id_transaction = %@", id)
        do {

            let fetchRequest = try managedContext.fetch(fetchRequest)
            if (fetchRequest.count > 0 ) {
                return false
            }
            return true
        }catch let err {
            print("err checkTrxId = \(err.localizedDescription)")
            return false
        }
    }
    
    func getAllTransaction(completion: @escaping(_ listTransaction: [TransactionModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Transaction")
        do {
            var listTransaction: [TransactionModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (transaction) in
                listTransaction.append(TransactionModel(
                idTransaction: transaction.value(forKey: "id_transaction") as! String,
                idPartner: transaction.value(forKey: "id_partner") as! String,
                totalPrice: transaction.value(forKey: "total_price") as! String,
                paymentCount: transaction.value(forKey: "payment_count") as! Int,
                document: transaction.value(forKey: "document") as! String,
                dueDate: transaction.value(forKey: "due_date") as! String,
                createdDate: transaction.value(forKey: "created_date") as! String,
                updatedDate: transaction.value(forKey: "updated_date") as! String,
                status: transaction.value(forKey: "status") as! TransactionStatusType,
                airtableId: transaction.value(forKey: "airtable_id") as! String))
            }
            completion(listTransaction, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
}
