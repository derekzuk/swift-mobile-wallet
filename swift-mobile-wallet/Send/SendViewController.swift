//
//  SendViewController.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/26/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit

class SendViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var trtlAddress: UITextView!
    @IBOutlet weak var trtlAmount: UILabel!
    @IBOutlet weak var usdAmountLabel: UILabel!
    
    let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    var usdPerTrtl: NSDecimalNumber = 0.0
    var placeholderText = "Enter TRTL Address"
    var tempBackgroundColor: UIColor = UIColor.lightGray
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set placeholder text
        if (SendVariable.globalTrtlAddress != "") {
            trtlAddress.text = SendVariable.globalTrtlAddress
            trtlAddress.textColor = .black
        } else {
            trtlAddress.text = placeholderText
            trtlAddress.textColor = .lightGray
        }
        usdAmountLabel.textColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrtlQuote()
        
        self.trtlAddress.delegate = self
    }
    
    // These methods allow a user to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == placeholderText && textView.textColor == .lightGray) {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "")
        {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
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
        // TODO: Check if address is valid
        // TODO: Check if trtlAmount.text > 0
        // TODO: Show a confirmation of some sort
        sendSimple()
    }
    
    @IBAction func button0Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "0")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button0(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button1Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "1")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button1(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button2Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "2")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button2(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button3Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "3")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button3(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button4Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "4")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button4(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button5Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "5")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button5(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button6Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "6")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button6(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button7Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "7")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button7(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button8Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "8")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button8(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func button9Down(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "9")
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func button9(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func buttonPeriodDown(_ sender: UIButton) {
        if (!trtlAmount.text!.contains(".")) {
            trtlAmount.text!.append(".")
        }
        tempBackgroundColor = sender.backgroundColor!
        sender.backgroundColor = UIColor(named: "lightGreen2")
    }
    @IBAction func buttonPeriod(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    @IBAction func buttonDeleteDown(_ sender: UIButton) {
        if (trtlAmount.text!.count > 1) {
            trtlAmount.text!.removeLast()
        } else {
            trtlAmount.text! = "0"
        }
        usdAmountLabel.text! = (NSDecimalNumber(string: trtlAmount.text!).multiplying(by: self.usdPerTrtl)).rounding(accordingToBehavior: self.handler).stringValue
    }
    @IBAction func buttonDelete(_ sender: UIButton) {
        sender.backgroundColor = tempBackgroundColor
    }
    
    // MARK: Private Methods
    
    private func addValueToTrtlAmount(numString: String) {
        // TODO: if result is greater than total owned quantity, make trtlAmount = total owned quantity
        
        if (trtlAmount.text!.elementsEqual("0")) {
            trtlAmount.text! = numString;
            usdAmountLabel.text! = (NSDecimalNumber(string: numString).multiplying(by: self.usdPerTrtl)).rounding(accordingToBehavior: self.handler).stringValue
        } else {
            trtlAmount.text!.append(numString);
            usdAmountLabel.text! = (NSDecimalNumber(string: trtlAmount.text!).multiplying(by: self.usdPerTrtl)).rounding(accordingToBehavior: self.handler).stringValue
        }
    }
    
    private func sendSimple() {
        let json: [String: Any] = [  "destination": trtlAddress.text!,
                                     "amount": Int(trtlAmount.text!)!]
        
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
    
    private func getTrtlQuote() {
        let urlString = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=TRTL"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("7ca858a7-dfcb-413b-974f-8b7161417caf", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
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
                let sub1 = json["data"] as! [String: Any]
                let sub2 = sub1["TRTL"] as! [String: Any]
                let sub3 = sub2["quote"] as! [String: Any]
                let sub4 = sub3["USD"] as! [String: Any]
                let price = sub4["price"] as! NSNumber
                self.usdPerTrtl = NSDecimalNumber(decimal: price.decimalValue)
            } catch {
                print(error)
            }
            }.resume()
    }
}
