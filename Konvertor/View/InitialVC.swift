//
//  InitialVC.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/22/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    let controller = CurrencyListController()
    
    // MARK: Properties
    
    // MARK: IBOutlets
    @IBOutlet weak var currencyInputButton: UIButton!
    @IBOutlet weak var currencyOutputButton: UIButton!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var amountOutput: UILabel!
    @IBOutlet weak var photoDetectButton: UIButton!
    @IBOutlet weak var currencyListTableView: UITableView!
    
    // MARK: IBActions
    
    @IBAction func changeCurrency(_ sender: UIButton) {
       amountInput.resignFirstResponder()
       currencyListTableView.isHidden = !currencyListTableView.isHidden
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
        currencyListTableView.delegate = self
        currencyListTableView.dataSource = self
        currencyListTableView.register([CurrencyCell.reuseIdentifier])
        currencyListTableView.layer.cornerRadius = 10

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

extension InitialVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}

extension InitialVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCurrency = controller.currencyList[indexPath.row]
        let cell = currencyListTableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.currencyAbbriviation.text = currentCurrency.abbriviation
        cell.currencyName.text = currentCurrency.currencyName
        return cell
    }
    
}

