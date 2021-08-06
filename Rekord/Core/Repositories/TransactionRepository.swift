//
//  TransactionRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 02/08/21.
//
import UIKit
import CoreData

class TransactionRepository {
    // prepare json data
    var jsonData: Data?

    // variable to store the data response that will be displayed
    var transactionNetworkModel: TransactionsNetworkData?
    
    static let shared = TransactionRepository()
    
    private init() {}
    
    
    //SAVE NEW BUSINESS AFTER SAVE USER
    func saveTransaction(transaction: TransactionModel, completion: @escaping (TransactionModel) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "fields" : [
                    "id_business": transaction.idBusiness!,
                    "id_partner": transaction.idPartner!,
                    "id_transaction": transaction.idTransaction!,
                    "total_price": transaction.totalPrice ?? "0",
                    "payment_count": transaction.paymentCount ?? "0",
                    "document": transaction.document ?? "",
                    "due_date": transaction.dueDate!,
                    "created_date": transaction.createdDate ?? "",
                    "updated_date": transaction.updatedDate ?? "",
                    "status": "waiting"
                ]
            ]]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //filter of table
        let filter = "Transactions"
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        TransactionsAPIRequest.createTransaction(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                    let transactionEntity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
                    let transactionData = NSManagedObject(entity: transactionEntity, insertInto: managedContext)
                    //VALUE SET CORE DATA TOBE SAVE
                    transactionData.setValue(response.records?.first?.fields?.id_transaction, forKeyPath: "id_transaction")
                    transactionData.setValue(response.records?.first?.fields?.id_business, forKeyPath: "id_business")
                    transactionData.setValue(response.records?.first?.fields?.id_partner, forKeyPath: "id_partner")
                    transactionData.setValue(response.records?.first?.fields?.status, forKeyPath: "status")
                    transactionData.setValue(response.records?.first?.fields?.document, forKeyPath: "document")
                    transactionData.setValue(response.records?.first?.fields?.total_price, forKeyPath: "total_price")
                    transactionData.setValue(response.records?.first?.fields?.created_date, forKeyPath: "created_date")
                    transactionData.setValue(response.records?.first?.fields?.updated_date, forKeyPath: "updated_date")
                    transactionData.setValue(response.records?.first?.fields?.due_date, forKeyPath: "due_date")
                    transactionData.setValue(response.records?.first?.fields?.payment_count, forKeyPath: "payment_count")
                    transactionData.setValue(response.records?.first?.id, forKeyPath: "airtable_id")
                    do {
                        try managedContext.save()
                        //SET USER CORE DATA TO CONTROLLER
                        transaction.airtableId = response.records?.first?.id
                        transaction.idTransaction = response.records?.first?.fields?.id_transaction
                        transaction.idBusiness = response.records?.first?.fields?.id_business
                        transaction.idPartner = response.records?.first?.fields?.id_partner
                        transaction.document = response.records?.first?.fields?.document
                        transaction.status = TransactionStatusType(rawValue: (response.records?.first?.fields?.status)!)
                        transaction.totalPrice = response.records?.first?.fields?.total_price ?? 0
                        transaction.createdDate = response.records?.first?.fields?.created_date
                        transaction.dueDate = response.records?.first?.fields?.created_date
                        transaction.updatedDate = response.records?.first?.fields?.due_date
                        transaction.paymentCount = response.records?.first?.fields?.payment_count ?? 0
                        completion(transaction)
                    } catch let error {
                        print("failed save user = \(error.localizedDescription)")
                        completion(transaction)
                    }
                    
                }
                //END SAVE CORE DATA
            }else{
                print("failed save user error on Airtable")
                completion(transaction)
            }
        } failCompletion: { message in
            //handle of failure
            //display alert failure
            //dismiss
            print(message)
        }
    }
    
    //UPDATE STATUS OF TRANSACTION
    //FOR CHANGE STATUS OR UPDATE PAYMENT COUNT OR TOTAL PRICE
    func updateTransaction(transaction: TransactionModel, completion: @escaping (_ status: Bool) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id" : transaction.airtableId!,
                "fields" : [
                    "status": transaction.status?.rawValue ?? "waiting",
                    "total_price": transaction.totalPrice ?? "0",
                    "payment_count": transaction.paymentCount ?? "0",
                    "updated_date": transaction.updatedDate ?? ""
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
        let formula = "?filterByFormula=AND(id_transaction%3D%22\(transaction.idTransaction!)%22)"
        
        // for filtering tabledata
        let filter = "Transactions"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if business that want to be updated already exist or not
        TransactionsAPIRequest.getTransactionsData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.transactionNetworkModel = response
            // check if user model not empty means data is exist
            if self.transactionNetworkModel?.records?.isEmpty == false{
                // post the data to API
                TransactionsAPIRequest.editTransaction(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Transaction")
                            fetchRequest.predicate = NSPredicate(format: "id_transaction = %@", transaction.idTransaction!)
                            //VALUE SET CORE DATA TOBE SAVE
                            do {
                                let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                                //VALUE SET CORE DATA TOBE SAVE
                                data.setValue(response.records?.first?.fields?.status, forKeyPath: "status")
                                data.setValue(response.records?.first?.fields?.total_price, forKeyPath: "total_price")
                                data.setValue(response.records?.first?.fields?.updated_date, forKeyPath: "updated_date")
                                data.setValue(response.records?.first?.fields?.payment_count, forKeyPath: "payment_count")
                                try managedContext.save()
                                completion(true)
                            }catch let err {
                                print("err = \(err.localizedDescription)")
                                completion(false)
                            }
                        }
                        //END SAVE CORE DATA
                    }else{
                        print("failed save transactions error on Airtable")
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
    
    //CHECK TRANSACTION
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
    
    //GET ALL TRANSACTION BASED ON RESPECTIVE BUSINESS
    func getAllTransaction(_idBusiness:String, completion: @escaping(_ listTransaction: [TransactionModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Transaction")
        fetchRequest.predicate = NSPredicate(format: "id_business = %@", _idBusiness)
        do {
            var listTransaction: [TransactionModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (transaction) in
                listTransaction.append(TransactionModel(
                    idTransaction: transaction.value(forKey: "id_transaction") as! String,
                    idPartner: transaction.value(forKey: "id_partner") as! String,
                    totalPrice: transaction.value(forKey: "total_price") as! Double,
                    paymentCount: transaction.value(forKey: "payment_count") as! Int,
                    document: transaction.value(forKey: "document") as! String,
                    dueDate: transaction.value(forKey: "due_date") as! String,
                    createdDate: transaction.value(forKey: "created_date") as! String,
                    updatedDate: transaction.value(forKey: "updated_date") as! String,
                    status: transaction.value(forKey: "status") as! TransactionStatusType,
                    airtableId: transaction.value(forKey: "airtable_id") as! String,
                    idBusiness: transaction.value(forKey: "id_business") as! String))
            }
            completion(listTransaction, nil)
        } catch let err {
            print("failed get all users = \(err.localizedDescription)")
            completion([], "Error Save")
        }
    }
}
