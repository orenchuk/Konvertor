//
//  InitialVC.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/22/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    
    // MARK: Properties
    
    // MARK: IBOutlets
    @IBOutlet weak var currencyInputButton: UIButton!
    @IBOutlet weak var currencyOutputButton: UIButton!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var amountOutput: UILabel!
    @IBOutlet weak var photoDetectButton: UIButton!
    
    // MARK: IBActions
    
    @IBAction func changeCurrency(_ sender: UIButton) {
    }
    
    @IBAction func keyboardTrigger(_ sender: UITextField) {
    }
    
    @IBAction func photoDetectAction(_ sender: UIButton) {
    }
    
    //add ApiKey
    lazy var currencyManager = APICurrencyManager(apiKey: "e08a5295b1f345d4b4aeb1d8d1dd0055")
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyManager.fetchCurrentCurrencyExchangeRateWith() { (result) in
            switch result {
            case .Success(let currentExchangeRate):
                print("ok")
                
                // For Sasha API library:
//                print(currentExchangeRate)
                print("Base currency:", currentExchangeRate.base)
                print("UAH rate:",  currentExchangeRate.rates["UAH"] ?? "N/A")
                //
            case .Failure(let error as NSError):
                print("fail")
                print(error)

                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    
}
