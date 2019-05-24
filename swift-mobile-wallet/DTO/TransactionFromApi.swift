//
//  TransactionFromApi.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/24/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import Foundation

struct TransactionFromApi: Codable{
    var blockHeight: Int
    var fee: Int
    var hash: String
    
    init(blockHeight: Int, fee: Int, hash: String) {
        self.blockHeight = blockHeight
        self.fee = fee
        self.hash = hash
    }
}
