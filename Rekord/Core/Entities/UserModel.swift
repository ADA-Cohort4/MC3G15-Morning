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
    
    init(idUser: String, appleId: String, passcode: String, role: RoleType, email: String, profileUrl: String) {
        self.idUser = idUser
        self.appleId = appleId
        self.passcode = passcode
        self.role = role
        self.email = email
        self.profileUrl = profileUrl
    }
}
