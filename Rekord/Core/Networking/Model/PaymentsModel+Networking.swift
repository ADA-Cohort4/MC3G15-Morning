//
//  PaymentsModel+Networking.swift
//  Rekord
//
//  Created by Julius Cesario on 31/07/21.
//

import Foundation

struct PaymentsNetworkData: Codable {
    let records: [PaymentsNetworkDataResponse]?
}

struct PaymentsNetworkDataResponse: Codable {
    let id: String?
    let fields: TransactionsNetworkDataFieldResponse?
    let createdTime: String?
}

struct PaymentsNetworkDataFieldResponse: Codable {
    let id_payment: String?
    let id_transaction: String?
    let id_user: String?
    let created_date: String?
    let amount: String?
    let document: String?
}
