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
        transactionData.setValue(transaction.status, forKeyPath: "status")
        
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
}
