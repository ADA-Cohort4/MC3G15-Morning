//
//  TransactionTypeStatus.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 28/07/21.
//

enum TransactionStatusType: String {
    case paid = "paid"
    case ongoing = "ongoing"
    case waiting = "waiting"
    case void = "void"
}

enum TransactionType: String, CaseIterable {
    case incoming = "incoming"
    case outgoing = "outgoing"
}

