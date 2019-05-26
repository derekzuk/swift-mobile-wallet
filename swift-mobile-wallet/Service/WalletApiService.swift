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
    
    public func retrieveTransactionsFromApi(transactionTableView: UITableView!) -> [Transaction] {
        var transactions = [Transaction]()
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
                    print("transaction: ")
                    print(transaction)
                    print(" ")
                    
                    var transfersArray = [Transfer]()
                    let transferArray = transaction["transfers"] as! [[String: Any]]
                    for transfer in transferArray {
                        print("transfer: ")
                        print(transfer)
                        print(" ")
                        let newTransfer = Transfer(address: transfer["address"] as! String, amount: transfer["amount"] as! Int)
                        transfersArray.append(newTransfer)
                        
                        let transactionForDisplay = Transaction(amount: transfer["amount"] as! Int,
                                                                photo: self.photo1,
                                                                address: transfer["address"] as! String,
                                                                timestamp: transaction["timestamp"] as! Int)
                        print("transactionForDisplay!: ")
                        print(transactionForDisplay!)
                        print("")
                        transactions.append(transactionForDisplay!)
                    }
                    
                    let transactionExtracted = transaction["hash"] as! String
                    print("transactionExtracted: ")
                    print(transactionExtracted)
                    print(" ")
                    
                    
                    
                    let transactionFromApi = TransactionFromApi(hash: transaction["hash"] as! String,
                                                                unlockTime: transaction["unlockTime"] as! Int,
                                                                paymentId: transaction["paymentId"] as? String ?? "",
                                                                timestamp: transaction["timestamp"] as! Int,
                                                                blockHeight: transaction["blockHeight"] as! Int,
                                                                transfers: transfersArray,
                                                                isCoinbaseTransaction: transaction["isCoinbaseTransaction"] as! Bool,
                                                                fee: transaction["fee"] as! Int)
                    print(transactionFromApi.description)
                    print(" ")
                    
                    // reloadData() must be dispatched from the main thread
                    DispatchQueue.main.async {
                        transactionTableView.reloadData()
                    }
                    
                    
                }
            } catch {
                print(error)
            }
        }.resume()
        return transactions
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
