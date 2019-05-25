//
//  TransactionFromApi.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/24/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import Foundation

struct TransactionFromApi: Codable{
    var hash: String
    var unlockTime: Int
    var paymentId: String
    var timestamp: Int
    var blockHeight: Int
    var transfers: [Transfer]
    var isCoinbaseTransaction: Bool
    var fee: Int
    
    init(hash: String, unlockTime: Int, paymentId: String, timestamp: Int, blockHeight: Int, transfers: [Transfer], isCoinbaseTransaction: Bool, fee: Int) {
        self.hash = hash
        self.unlockTime = unlockTime
        self.paymentId = paymentId
        self.timestamp = timestamp
        self.blockHeight = blockHeight
        self.transfers = transfers
        self.isCoinbaseTransaction = isCoinbaseTransaction
        self.fee = fee
    }
    
    // TODO: Finish description implementation
    var description: String {
        return "TransactionFromApi: hash:\(hash), unlockTime:\(unlockTime), paymentId:\(paymentId), timestamp:\(timestamp)"
    }
}
