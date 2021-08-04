//
//  TransactionModel.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

class TransactionModel {
    var idTransaction: String?
    var idPartner: String?
    var idBusiness: String?
    var totalPrice: Float?
    var paymentCount: Int?
    var document: String?
    var dueDate: String?
    var createdDate: String?
    var updatedDate: String?
    var status: TransactionStatusType?
    var airtableId: String?
    
    init(idTransaction: String, idPartner: String, totalPrice: Float, paymentCount: Int, document: String, dueDate: String, createdDate: String, updatedDate: String, status: TransactionStatusType, airtableId: String, idBusiness: String) {
        self.idTransaction = idTransaction
        self.idPartner = idPartner
        self.idBusiness = idBusiness
        self.totalPrice = totalPrice
        self.paymentCount = paymentCount
        self.document = document
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.status = status
        self.airtableId = airtableId
    }
}


