//
//  TransactionModel.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

class TransactionModel {
    var idTransaction: String?
    var idPartner: String?
    var totalPrice: Float?
    var paymentCount: Int?
    var document: String?
    var dueDate: String?
    var createdDate: String?
    var updatedDate: String?
    var status: TransactionStatusType?
    
    init(idTransaction: String, idPartner: String, totalPrice: Float, paymentCount: Int, document: String, dueDate: String, createdDate: String, updatedDate: String, status: TransactionStatusType) {
        self.idTransaction = idTransaction
        self.idPartner = idPartner
        self.totalPrice = totalPrice
        self.paymentCount = paymentCount
        self.document = document
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.status = status
    }
}
