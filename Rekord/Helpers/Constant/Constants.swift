//
//  Constants.swift
//  Rekord
//
//  Created by Julius Cesario on 03/05/21.
//

import Foundation
import UIKit

class Constants  {
    
    static let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let footerHeight = 100
    static let dataModel = "Rekord"
    static let globalUserEmail = "info@rekord.org"
    static let globalUserFirstName = "Rekord"
    static let globalUserLastName = "13"
    static let globalUserPasword = "info@rekord.org"
    static let TypeTransactionList = ["Expense","Income"]
    static let CategoryBusinessList = ["Utilities","Transportation","Workstation"]
    static let CategoryPersonalList = ["Utilities","Transportation","Games"]
    static let HEADER_URL = ["Authorization": "Bearer keyapsxyrejarJKHb",
                             "Content-Type": "application/json",
                             "Accept": "application/json"]
    static let NETWORK_URL = "https://api.airtable.com/v0/appEZWGomcyIcENLJ/"
}
