//
//  InviteLinksModel+Networking.swift
//  Rekord
//
//  Created by Julius Cesario on 31/07/21.
//

import Foundation

struct InviteLinksNetworkData: Codable {
    let records: [InviteLinksNetworkDataResponse]?
}

struct InviteLinksNetworkDataResponse: Codable {
    let id: String?
    let fields: InviteLinksNetworkDataFieldResponse?
    let createdTime: String?
}

struct InviteLinksNetworkDataFieldResponse: Codable {
    let id_invitelink: String?
    let id_user: String?
    let id_recepient: String?
    let status: String?
    let created_date: String?
}
