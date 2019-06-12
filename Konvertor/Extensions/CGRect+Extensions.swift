//
//  CGRect+Extensions.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 6/11/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

extension CGRect {
    func scaleUp(scaleUp: CGFloat) -> CGRect {
        let biggerRect = self.insetBy(
            dx: -self.size.width * scaleUp,
            dy: -self.size.height * scaleUp
        )
        
        return biggerRect
    }
}
