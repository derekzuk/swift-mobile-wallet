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
    
    var placeholderText = "Enter TRTL Address"
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func button0(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "0")
    }
    @IBAction func button1(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "1")
    }
    @IBAction func button2(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "2")
    }
    @IBAction func button3(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "3")
    }
    @IBAction func button4(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "4")
    }
    @IBAction func button5(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "5")
    }
    @IBAction func button6(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "6")
    }
    @IBAction func button7(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "7")
    }
    @IBAction func button8(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "8")
    }
    @IBAction func button9(_ sender: UIButton) {
        addValueToTrtlAmount(numString: "9")
    }
    @IBAction func buttonPeriod(_ sender: UIButton) {
        if (!trtlAmount.text!.contains(".")) {
            trtlAmount.text!.append(".")
        }
    }
    @IBAction func buttonDelete(_ sender: UIButton) {
        if (trtlAmount.text!.count > 1) {
            trtlAmount.text!.removeLast()
        } else {
            trtlAmount.text! = "0"
        }
    }
    
    
    // MARK: Private Methods
    
    private func addValueToTrtlAmount(numString: String) {
        // TODO: if result is greater than total owned quantity, make trtlAmount = total owned quantity
        
        if (trtlAmount.text!.elementsEqual("0")) {
            trtlAmount.text! = numString;
        } else {
            trtlAmount.text!.append(numString);
        }
        
    }
    
    private func sendSimple() {
        // prepare json data
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

}
