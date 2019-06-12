//
//  ReceiveViewController.swift
//  swift-mobile-wallet
//
//  Created by Derek Zuk on 5/27/19.
//  Copyright © 2019 Derek Zuk. All rights reserved.
//

import UIKit

class ReceiveViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var myAddressLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAddressLabel.text = "TRTLv2ZheheiYNFuGj2ka2eSipa4GxxVH9VNKz9rQFsog4jMJKrt9UXPwmogxmnkLrEp3EYpzqK5hWazA7HY9MKXb5F1NccELik"

        qrCodeImage.image = generateQRCode(from: myAddressLabel.text!)
    }
    
    // MARK: Action
    
    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = myAddressLabel.text!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
    }
    
    // MARK: Private Methods
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
}
