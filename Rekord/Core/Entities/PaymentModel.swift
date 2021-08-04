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
    var amount: String?
    var document: String?
    var airtableId: String?
    
    init(idPayment: String, idTransaction: String, idUser: String, createdDate: String, amount: String, document: String, airtableId: String) {
        self.idPayment = idPayment
        self.idTransaction = idTransaction
        self.idUser = idUser
        self.createdDate = createdDate
        self.amount = amount
        self.document = document
        self.airtableId = airtableId
    }
}
