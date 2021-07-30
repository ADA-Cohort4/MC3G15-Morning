//
//  InviteLinkModel.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 30/07/21.
//

import Foundation

class InviteLinkModel {
    var idInviteLink: String?
    var idUser: String?
    var idRecepient: String?
    var status: InvitationActivationStatus?
    var createdDate: String?
    
    init(idInviteLink: String, idUser: String, idRecepient: String, status: InvitationActivationStatus, createdDate: String) {
        self.idInviteLink = idInviteLink
        self.idUser = idUser
        self.idRecepient = idRecepient
        self.status = status
        self.createdDate = createdDate
    }
}
