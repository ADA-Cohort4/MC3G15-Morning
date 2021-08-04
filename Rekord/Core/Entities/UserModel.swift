//
//  UserModel.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

import Foundation

class UserModel {
    var idUser: String?
    var appleId: String?
    var passcode: String?
    var role: RoleType?
    var email: String?
    var profileUrl: String?
    var phone: String?
    var airtableId: String?
    var status: String?
    init(idUser: String, appleId: String, passcode: String, role: RoleType, email: String, profileUrl: String, phone: String, airtableId: String, status: String) {
        self.idUser = idUser
        self.appleId = appleId
        self.passcode = passcode
        self.role = role
        self.email = email
        self.profileUrl = profileUrl
        self.phone = phone
        self.airtableId = airtableId
        self.status = status
    }
}
