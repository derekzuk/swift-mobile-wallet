//
//  Transaction.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/19/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit

class Transaction: Hashable {
    
    // TODO: Insuficient comparison?
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.amount == rhs.amount && lhs.timestamp == rhs.timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(timestamp)
    }
    
    //MARK: Properties
    
    var amount: Int
    var photo: UIImage?
    var address: String
    var timestamp: Int
    
    //MARK: Initialization
    
    init?(amount: Int, photo: UIImage?, address: String, timestamp: Int) {
        // Initialization should fail if there is no address
        // The address must not be empty
        guard !address.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.amount = amount
        self.photo = photo
        self.address = address
        self.timestamp = timestamp
    }
    
}
