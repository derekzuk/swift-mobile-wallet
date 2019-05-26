//
//  TransactionTableViewController.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/19/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit
import JavaScriptCore

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TODO: We can maybe just use the etherscan API to make something interesting
    // https://etherscan.io/apis#accounts
    
    // MARK: Properties
    @IBOutlet weak var transactionTableView: UITableView!
    
    var transactions = [Transaction]()
    var transactionsFromApi = [TransactionFromApi]()
    var addresses = [String]()
    let photo1 = UIImage(named: "sendImage")
    let photo2 = UIImage(named: "receiveImage")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        transactionTableView.delegate = self
        transactionTableView.dataSource = self

        retrieveTransactionsFromApi()
        retrieveAddresses()
        
        loadTransactions()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return transactions.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TransactionTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransactionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TransactionTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let transaction = transactions[indexPath.row]
        
        cell.quantityLabel.text = String(transaction.amount)
        cell.transactionImage.image = transaction.photo
        cell.addressLabel.text = transaction.address
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadTransactions() {
        guard let transaction1 = Transaction(amount: 283719, photo: self.photo1, address: "1908clkcn02dj") else {
            fatalError("Unable to instantiate transaction1")
        }
        
        guard let transaction2 = Transaction(amount: 131, photo: self.photo2, address: "cms93jcls832") else {
            fatalError("Unable to instantiate transaction2")
        }
        
        guard let transaction3 = Transaction(amount: 91239, photo: self.photo1, address: "ck83nclls8") else {
            fatalError("Unable to instantiate transaction3")
        }
        
        transactions += [transaction1, transaction2, transaction3]
    }
    
    private func retrieveTransactionsFromApi() {
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
                        var newTransfer = Transfer(address: transfer["address"] as! String, amount: transfer["amount"] as! Int)
                        transfersArray.append(newTransfer)

                        var transactionForDisplay = Transaction(amount: transfer["amount"] as! Int,
                                                                photo: self.photo1,
                                                                address: transfer["address"] as! String)
                        print("transactionForDisplay!: ")
                        print(transactionForDisplay!)
                        print("")
                        self.transactions.append(transactionForDisplay!)
                    }
                    
                    let transactionExtracted = transaction["hash"] as! String
                    print("transactionExtracted: ")
                    print(transactionExtracted)
                    print(" ")
                    
                    
                    
                    var transactionFromApi = TransactionFromApi(hash: transaction["hash"] as! String,
                                                                unlockTime: transaction["unlockTime"] as! Int,
                                                                paymentId: transaction["paymentId"] as? String ?? "",
                                                                timestamp: transaction["timestamp"] as! Int,
                                                                blockHeight: transaction["blockHeight"] as! Int,
                                                                transfers: transfersArray,
                                                                isCoinbaseTransaction: transaction["isCoinbaseTransaction"] as! Bool,
                                                                fee: transaction["fee"] as! Int)
                    print(transactionFromApi.description)
                    print(" ")

                    // TODO: UITableView.reloadData() must be used from main thread only
//                    self.transactionTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    private func retrieveAddresses() {
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
                self.addresses = json["addresses"] as! [String]
                print("self.addresses: ")
                print(self.addresses)
                print(" ")
            } catch {
                print(error)
            }
        }.resume()
    }

}
