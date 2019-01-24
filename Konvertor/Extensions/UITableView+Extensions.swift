//
//  UITableView+Extensions.swift
//  Konvertor
//
//  Created by Олександр Потапов on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

extension UITableView{
    func register(_ identifiers: [String]){
        for identifier in identifiers{
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        }
    }
}
