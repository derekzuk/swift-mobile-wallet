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
    
    private func retrieveTransactionsFromApi(completion: @escaping (_ retrievedTransactions: [Transaction]) -> Void) {
        var retrievedTransactions = [Transaction]()
        let urlString = "http://127.0.0.1:8070/transactions"
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
                let transactionsArray = json["transactions"] as! [[String: Any]]
                for transaction in transactionsArray {
                    var transfersArray = [Transfer]()
                    let transferArray = transaction["transfers"] as! [[String: Any]]
                    for transfer in transferArray {
                        let newTransfer = Transfer(address: transfer["address"] as! String, amount: transfer["amount"] as! Int)
                        transfersArray.append(newTransfer)
                        
                        let transactionForDisplay = Transaction(amount: transfer["amount"] as! Int,
                                                                photo: transfer["amount"] as! Int > 0 ? self.photo1 : self.photo2,
                                                                address: transfer["address"] as! String,
                                                                timestamp: transaction["timestamp"] as! Int)
                        // We only add the transaction if it is not already contained in the transaction array
                        if (!retrievedTransactions.contains(transactionForDisplay!)) {
                            retrievedTransactions.append(transactionForDisplay!)
                        }
                    }
                    
//                    let transactionExtracted = transaction["hash"] as! String
//
//                    let transactionFromApi = TransactionFromApi(hash: transaction["hash"] as! String,
//                                                                unlockTime: transaction["unlockTime"] as! Int,
//                                                                paymentId: transaction["paymentId"] as? String ?? "",
//                                                                timestamp: transaction["timestamp"] as! Int,
//                                                                blockHeight: transaction["blockHeight"] as! Int,
//                                                                transfers: transfersArray,
//                                                                isCoinbaseTransaction: transaction["isCoinbaseTransaction"] as! Bool,
//                                                                fee: transaction["fee"] as! Int)
                }
            } catch {
                print(error)
            }
            
            completion(retrievedTransactions)
            }.resume()
    }
    
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
