//
//  PaymentModel.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

class PaymentModel {
    var idPayment: String?
    var idTransaction: String?
    var idUser: String
    var createdDate: String?
    var amount: Float?
    var document: String?
    
    init(idPayment: String, idTransaction: String, idUser: String, createdDate: String, amount: Float, document: String) {
        self.idPayment = idPayment
        self.idTransaction = idTransaction
        self.idUser = idUser
        self.createdDate = createdDate
        self.amount = amount
        self.document = document
    }
}
