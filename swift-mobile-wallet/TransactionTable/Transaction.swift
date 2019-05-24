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
    
    var quantity: String
    var photo: UIImage?
    var address: String
    
    //MARK: Initialization
    
    init?(quantity: String, photo: UIImage?, address: String) {
        // Initialization should fail if there is no quantity or address
        // The name must not be empty
        guard !quantity.isEmpty else {
            return nil
        }
        
        // The address must not be empty
        guard !address.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.quantity = quantity
        self.photo = photo
        self.address = address
    }    
    
}
