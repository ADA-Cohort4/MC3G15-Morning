//
//  InviteLinksModel+Networking.swift
//  Rekord
//
//  Created by Julius Cesario on 31/07/21.
//

import Foundation

struct InviteLinksData: Codable {
    let records: [InviteLinksDataResponse]?
}

struct InviteLinksDataResponse: Codable {
    let id: String?
    let fields: InviteLinksDataFieldResponse?
    let createdTime: String?
}

struct InviteLinksDataFieldResponse: Codable {
    let id_invitelink: String?
    let id_user: String?
    let id_recepient: String?
    let status: String?
    let created_date: String?
}
