//
//  BusinessModel+Networking.swift
//  Rekord
//
//  Created by Julius Cesario on 31/07/21.
//

import Foundation

struct BusinessNetworkData: Codable {
    let records: [BusinessNetworkDataResponse]?
}

struct BusinessNetworkDataResponse: Codable {
    let id: String?
    let fields: BusinessNetworkDataFieldResponse?
    let createdTime: String?
}

struct BusinessNetworkDataFieldResponse: Codable {
    let id_business: String?
    let id_user: String?
    let name: String?
    let email: String?
    let phone: String?
    let address: String?
    let status: String?
}

