//
//  CIImage+Extension.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 6/11/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

extension CIImage {
    func toUIImage() -> UIImage? {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(self, forKey: kCIInputImageKey)
        guard let output = currentFilter!.outputImage else { return nil }
        if let cgImage = context.createCGImage(output, from: self.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
