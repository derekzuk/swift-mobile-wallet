//
//  SendViewController.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/26/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    
    // MARK: Properties
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
     @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
     }
     
     @IBAction func camera(_ sender: UIBarButtonItem) {
     }
    
    // Mark: Action
    @IBAction func sendButtonClick(_ sender: UIButton) {
        print("clicked Send button")
        sendSimple()
    }
    
    // MARK: Private Methods
    
    private func sendSimple() {
        // prepare json data
        let json: [String: Any] = [  "destination": "TRTLuzJzyboDALnqwsQMt6DGW665JsYFnHgECQo6rcWuQZNZ5dtY5zTGUnHHcp7tdeKErjgWvrwTGZccRm35AiAhWaveSRCstpW",
                                     "amount": 123]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let urlString = "http://127.0.0.1:8070/transactions/send/basic"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("password", forHTTPHeaderField: "X-API-KEY")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "Error encountered printing the error")
                return
            }
            }.resume()
    }

}
