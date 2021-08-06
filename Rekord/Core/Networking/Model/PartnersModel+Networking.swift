//
//  PartnersModel+Networking.swift
//  Rekord
//
//  Created by Julius Cesario on 31/07/21.
//

import Foundation

struct PartnersNetworkData: Codable {
    let records: [PartnersNetworkDataResponse]?
}

struct PartnersNetworkDataResponse: Codable {
    let id: String?
    let fields: PartnersNetworkDataFieldResponse?
    let createdTime: String?
}

struct PartnersNetworkDataFieldResponse: Codable {
    let id_partner: String?
    let id_user: String?
    let id_business: String?
    let name: String?
    let phone: String?
    let type: String?
    let status: String?
}

