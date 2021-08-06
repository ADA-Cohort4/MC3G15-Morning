//
//  TransactionsModel+Networking.swift
//  Rekord
//
//  Created by Julius Cesario on 31/07/21.
//

import Foundation

struct TransactionsNetworkData: Codable {
    let records: [TransactionsNetworkDataResponse]?
}

struct TransactionsNetworkDataResponse: Codable {
    let id: String?
    let fields: TransactionsNetworkDataFieldResponse?
    let createdTime: String?
}

struct TransactionsNetworkDataFieldResponse: Codable {
    let id_transaction: String?
    let id_partner: String?
//    let id_business: String?
    let total_price: String?
    let payment_count: String?
    let document: String?
    let due_date: String?
    let created_date: String?
    let updated_date: String?
    let status: String?
}

