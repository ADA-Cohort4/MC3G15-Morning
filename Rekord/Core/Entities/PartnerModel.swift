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
    var phone: String?
    var status: PartnerActivationStatus?
    
    init(idPartner: String, idUser: String, type: PartnerType, phone: String, status: PartnerActivationStatus) {
        self.idPartner = idPartner
        self.idUser = idUser
        self.type = type
        self.phone = phone
        self.status = status
    }
}
