//
//  Partner.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

class PartnerModel {
    var idPartner: String?
    var idBusiness: String?
    var type: PartnerType?
    
    init(idPartner: String, idBusiness: String, type: PartnerType) {
        self.idPartner = idPartner
        self.idBusiness = idBusiness
        self.type = type
    }
}
