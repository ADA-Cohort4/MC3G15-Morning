//
//  Partner.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

class PartnerModel {
    var idPartner: String?
    var idUser: String?
    var type: PartnerType?
    var name: String?
    var phone: String?
    var status: PartnerActivationStatus?
    var airtableId: String?
    var idBusiness: String?
    var address: String?
    var email: String?
    var ownerName : String?
    
    init(idPartner: String, idUser: String, idBusiness: String, type: PartnerType, name:String, phone: String, status: PartnerActivationStatus, airtableId: String, address: String, email: String, ownerName : String) {
        self.idPartner = idPartner
        self.idUser = idUser
        self.idBusiness = idBusiness
        self.name = name
        self.type = type
        self.phone = phone
        self.status = status
        self.airtableId = airtableId
        self.address = address
        self.email = email
        self.ownerName = ownerName
        
    }
}
