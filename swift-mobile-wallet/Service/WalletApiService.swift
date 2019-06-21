//
//  WalletApiService.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/26/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit
import Foundation

class WalletApiService {
    
    let photo1 = UIImage(named: "sendImage")
    let photo2 = UIImage(named: "receiveImage")
    
    public func retrieveAddresses(addresses: [String]) -> [String] {
        var addresses = [String]()
        let urlString = "http://127.0.0.1:8070/addresses"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("password", forHTTPHeaderField: "X-API-KEY")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "Error encountered printing the error")
                return
            }
            
            do {
                guard let data = data else { return }
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                addresses = json["addresses"] as! [String]
                print("self.addresses: ")
                print(addresses)
                print(" ")
            } catch {
                print(error)
            }
            }.resume()
        return addresses
    }
}
