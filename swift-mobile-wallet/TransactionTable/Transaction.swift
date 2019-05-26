//
//  Transaction.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/19/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit

class Transaction {
    
    //MARK: Properties
    
    var amount: Int
    var photo: UIImage?
    var address: String
    
    //MARK: Initialization
    
    init?(amount: Int, photo: UIImage?, address: String) {
        // Initialization should fail if there is no address
        // The address must not be empty
        guard !address.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.amount = amount
        self.photo = photo
        self.address = address
    }
    
}
