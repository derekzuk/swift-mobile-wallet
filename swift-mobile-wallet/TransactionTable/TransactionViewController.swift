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
    
    // MARK: Properties
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var trtlWalletQuantity: UILabel!
    
    var address: String = "TRTLv2ZheheiYNFuGj2ka2eSipa4GxxVH9VNKz9rQFsog4jMJKrt9UXPwmogxmnkLrEp3EYpzqK5hWazA7HY9MKXb5F1NccELik"
    var transactions = [Transaction]()
    var transactionsFromApi = [TransactionFromApi]()
    var addresses = [String]()
    let photo1 = UIImage(named: "sendImage")
    let photo2 = UIImage(named: "receiveImage")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        trtlWalletQuantity.text = "Retrieving Wallet..."
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        // Set row height
        transactionTableView.rowHeight = 70

        // We check that the wallet is open first before populating transactions
        // TODO: Opening wallet not working
        openWallet(completion: {() in
            self.retrieveTransactionsFromApi(completion: {() in
                // Reorder list
                self.transactions.sort(by: { (t1, t2) -> Bool in
                    return t1.timestamp > t2.timestamp
                })
                // reloadData() must be dispatched from the main thread
                DispatchQueue.main.async {
                    self.transactionTableView.reloadData()
                }
            })
            
            // TODO: Get address
            
            self.getBalanceByAddress(address: self.address, completion: {(quantity) in
                DispatchQueue.main.async {
                    self.trtlWalletQuantity.text = quantity + " TRTL"
                }
            })
            
            // TODO: this is not necessary at the moment
            self.retrieveAddresses()
        })
        
//        loadTestTransactions()
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
        cell.addressLabel.text = transaction.dateString
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func settings(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        retrieveTransactionsFromApi(completion: {() in
            // Reorder list
            self.transactions.sort(by: { (t1, t2) -> Bool in
                return t1.timestamp > t2.timestamp
            })
            // reloadData() must be dispatched from the main thread
            DispatchQueue.main.async {
                self.transactionTableView.reloadData()
            }
        })
        
        self.getBalanceByAddress(address: self.address, completion: {(quantity) in
            DispatchQueue.main.async {
                self.trtlWalletQuantity.text = quantity + " TRTL"
            }
        })
    }
    
    
    //MARK: Private Methods
    
    private func loadTestTransactions() {
        guard let transaction1 = Transaction(amount: 283719, photo: self.photo1, dateString: "1908clkcn02dj", timestamp: 12345) else {
            fatalError("Unable to instantiate transaction1")
        }
        
        guard let transaction2 = Transaction(amount: 131, photo: self.photo2, dateString: "cms93jcls832", timestamp: 12345) else {
            fatalError("Unable to instantiate transaction2")
        }
        
        guard let transaction3 = Transaction(amount: 91239, photo: self.photo1, dateString: "ck83nclls8", timestamp: 12345) else {
            fatalError("Unable to instantiate transaction3")
        }
        
        transactions += [transaction1, transaction2, transaction3]
    }
    
    private func openWallet(completion: @escaping () -> Void) {
        let urlString = "http://127.0.0.1:8070/wallet/open"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        // prepare json data
        let json: [String: Any] = ["daemonHost": "127.0.0.1",
                                   "daemonPort": 11898,
                                   "filename": "mywallet.wallet",
                                   "password": "supersecretpassword"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.setValue("password", forHTTPHeaderField: "X-API-KEY")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "Error encountered printing the error")
                return
                // TODO: Check if response is successful before proceeding to completion()
            } else {
                completion()
            }
        }.resume()
    }
    
    private func retrieveTransactionsFromApi(completion: @escaping () -> Void) {
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
                        
                        // Create dateString
                        var timeInt = transaction["timestamp"] as! Int
                        let date = Date(timeIntervalSince1970: TimeInterval(timeInt))
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
                        dateFormatter.locale = Locale.init(identifier: "en_ES")
                        
                        let dateObj = dateFormatter.string(from:date)
                        
                        let transactionForDisplay = Transaction(amount: abs(transfer["amount"] as! Int),
                                                                photo: transfer["amount"] as! Int > 0 ? self.photo2 : self.photo1,
                                                                dateString: dateObj,
                                                                timestamp: transaction["timestamp"] as! Int)
                        // We only add the transaction if it is not already contained in the transaction array
                        if (!self.transactions.contains(transactionForDisplay!)) {
                            self.transactions.append(transactionForDisplay!)
                        }
                    }
                    
                    let transactionExtracted = transaction["hash"] as! String

                    let transactionFromApi = TransactionFromApi(hash: transaction["hash"] as! String,
                                                                unlockTime: transaction["unlockTime"] as! Int,
                                                                paymentId: transaction["paymentId"] as? String ?? "",
                                                                timestamp: transaction["timestamp"] as! Int,
                                                                blockHeight: transaction["blockHeight"] as! Int,
                                                                transfers: transfersArray,
                                                                isCoinbaseTransaction: transaction["isCoinbaseTransaction"] as! Bool,
                                                                fee: transaction["fee"] as! Int)
                }
            } catch {
                print(error)
            }
            
            completion()
        }.resume()
    }
    
    private func getBalanceByAddress(address: String, completion: @escaping (String) -> Void) {
        let urlString = "http://127.0.0.1:8070/balance/" + address
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
                completion(String(json["unlocked"] as! Int))
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
            } catch {
                print(error)
            }
        }.resume()
    }

}
