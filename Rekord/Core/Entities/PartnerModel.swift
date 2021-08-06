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
    
    init(idPartner: String, idUser: String, type: PartnerType, name:String, phone: String, status: PartnerActivationStatus, airtableId: String) {
        self.idPartner = idPartner
        self.idUser = idUser
        self.name = name
        self.type = type
        self.phone = phone
        self.status = status
        self.airtableId = airtableId
    }
}
