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
       currencyListTableView.isHidden = !currencyListTableView.isHidden
        }
    
    
    @IBAction func keyboardTrigger(_ sender: UITextField) {
    }
    
    @IBAction func photoDetectAction(_ sender: UIButton) {
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyListTableView.delegate = self
        currencyListTableView.dataSource = self
        currencyListTableView.register([CurrencyCell.reuseIdentifier])
    }


}

extension InitialVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
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
