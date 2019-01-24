//
//  UITableViewCell+Extension.swift
//  Konvertor
//
//  Created by Олександр Потапов on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit
extension UITableViewCell{
    static var reuseIdentifier: String{
        let str = NSStringFromClass(self)
        return str.components(separatedBy: ".").last!
    }
}
