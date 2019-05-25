//
//  Transfer.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/25/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import Foundation

struct Transfer: Codable{
    var address: String
    var amount: Int
    
    init(address: String, amount: Int) {
        self.address = address
        self.amount = amount
    }
}
