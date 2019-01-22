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
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

