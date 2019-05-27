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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}
