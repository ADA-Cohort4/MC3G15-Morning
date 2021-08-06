//
//  PaymentRepository.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 03/08/21.
//
import UIKit
import CoreData

class PaymentRepository {
    
    // prepare json data
    var jsonData: Data?

    // variable to store the data response that will be displayed
    var paymentNetworkModel: PaymentsNetworkData?
    
    static let shared = PaymentRepository()
    
    private init() {}
    
    //SAVE NEW PAYMENTS
    func savePayments(payment: PaymentModel, completion: @escaping (PaymentModel) -> Void) {
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "fields" : [
                    "id_business": payment.idPayment!,
                    "id_transaction": payment.idTransaction!,
                    "id_user": payment.idUser!,
                    "created_date": payment.createdDate!,
                    "amount": payment.amount ?? 0,
                    "document": payment.document ?? "",
                ]
            ]]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        // for filtering tabledata
        let filter = "Payments"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if Payment that want to be registered already exist or not
        PaymentsAPIRequest.createPayment(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
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
                    let paymentEntity = NSEntityDescription.entity(forEntityName: "Payment", in: managedContext)!
                    let paymentData = NSManagedObject(entity: paymentEntity, insertInto: managedContext)
                    //VALUE SET CORE DATA TOBE SAVE
                    paymentData.setValue(response.records?.first?.fields?.id_user, forKeyPath: "id_user")
                    paymentData.setValue(response.records?.first?.fields?.id_payment, forKeyPath: "id_payment")
                    paymentData.setValue(response.records?.first?.fields?.id_transaction, forKeyPath: "id_transaction")
                    paymentData.setValue(response.records?.first?.fields?.amount, forKeyPath: "amount")
                    paymentData.setValue(response.records?.first?.fields?.created_date, forKeyPath: "created_date")
                    paymentData.setValue(response.records?.first?.fields?.document, forKeyPath: "document")
                    paymentData.setValue(response.records?.first?.id, forKeyPath: "airtable_id")
                    do {
                        try managedContext.save()
                        //SET USER CORE DATA TO CONTROLLER
                        payment.airtableId = response.records?.first?.id
                        payment.idUser = response.records?.first?.fields?.id_user
                        payment.idPayment = response.records?.first?.fields?.id_payment
                        payment.idTransaction = response.records?.first?.fields?.id_transaction
                        payment.amount = Float(response.records?.first?.fields?.amount ?? "0")
                        payment.createdDate = response.records?.first?.fields?.created_date
                        payment.document = response.records?.first?.fields?.document
                        completion(payment)
                    } catch let error {
                        print("failed save user = \(error.localizedDescription)")
                        completion(payment)
                    }
                }
                //END SAVE CORE DATA
            }else{
                print("failed save payment error on Airtable")
                completion(payment)
            }
        } failCompletion: { message in
            //handle of failure
            //display alert failure
            //dismiss
            print(message)
        }
    }
    
    //GET Payment BY BY ID transaction
    func getPayment(_ idTransaction: String, completion: @escaping(PaymentModel) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "id_transaction = %@", idTransaction)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            //SET USER CORE DATA TO CONTROLLER
            let paymentData = PaymentModel(
                idPayment: data.value(forKey: "id_payment") as! String,
                idTransaction: data.value(forKey: "id_transaction") as! String,
                idUser: data.value(forKey: "id_user") as! String,
                createdDate: data.value(forKey: "created_date") as! String,
                amount: data.value(forKey: "amount")  as! Float,
                document: data.value(forKey: "document") as! String,
                airtableId: data.value(forKey: "airtable_id") as! String)
            completion(paymentData)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            let paymentData = PaymentModel(idPayment: "", idTransaction: "", idUser: "", createdDate: "", amount: 0, document: "", airtableId: "")
            completion(paymentData)
        }
    }
    
    //GET ALL PAYMENT by ID USER
    func getAllPayment(_ idUser:String, completion: @escaping(_ listPayment: [PaymentModel], _ error: String?) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "id_user = %@", idUser)
        do {
            var listPayment: [PaymentModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (payment) in
                listPayment.append(PaymentModel(
                idPayment: payment.value(forKey: "id_payment") as! String,
                idTransaction: payment.value(forKey: "id_payment") as! String,
                idUser: payment.value(forKey: "id_user") as! String,
                createdDate: payment.value(forKey: "created_date") as! String,
                amount: payment.value(forKey: "amount") as! Float,
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
