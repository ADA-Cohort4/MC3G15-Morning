//
//  LearningDataModel.swift
//  get-post-Airtable
//
//  Created by khoirunnisa' rizky noor fatimah on 20/07/21.
//

import Foundation

struct UsersNetworkData: Codable {
    let records: [UsersNetworkDataResponse]?
}

struct UsersNetworkDataResponse: Codable {
    let id: String?
    let fields: UsersNetworkDataFieldResponse?
    let createdTime: String?
}

struct UsersNetworkDataFieldResponse: Codable {
    let email: String?
    let apple_id: String?
    let role: String?
    let passcode: String?
    let id_user: String?
    let phone: String?
    let name: String?
    let profile_url: String?
}
