//
//  BusinessModel.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

class BusinessModel {
    var idBusiness: String?
    var idUser: String?
    var name: String?
    var email: String?
    var phone: String?
    var address: String?
    var airtableId: String?
    
    init(idBusiness: String, idUser: String, name: String, email: String, phone: String, address: String, airtableId: String) {
        self.idBusiness = idBusiness
        self.idUser = idUser
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.airtableId = airtableId
    }
}
