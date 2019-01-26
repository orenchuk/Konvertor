//
//  LiveTextDetectionController.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/25/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class LiveTextDetectionController: NSObject {
    
    // MARK: Properties
    
    let preview: UIView
    var requests = [VNRequest]()
    
    init(preview: UIView) {
        self.preview = preview
    }
    
    // MARK: Methods
    
    func startTextDetection() {
        let textRequest = VNDetectTextRectanglesRequest { (request, error) in
            guard let observations = request.results else {
                print("no result")
                return
            }
            
            let result = observations.map({$0 as? VNTextObservation})
            
            DispatchQueue.main.async() {
                self.preview.layer.sublayers?.removeSubrange(1...)
                for region in result {
                    guard let rg = region else {
                        continue
                    }
                    
                    self.highlightWord(box: rg)
                }
            }
        }
        
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    private func highlightWord(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else { return }
        
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < maxX {
                if char.bottomLeft.x < maxX {
                    maxX = char.bottomLeft.x
                }
                if char.bottomRight.x > minX {
                    minX = char.bottomRight.x
                }
                if char.bottomRight.y < maxY {
                    maxY = char.bottomRight.y
                }
                if char.topRight.y > minY {
                    minY = char.topRight.y
                }
            }
        }
        
        let xCord = maxX * preview.frame.size.width
        let yCord = (1 - minY) * preview.frame.size.height
        let width = (minX - maxX) * preview.frame.size.width
        let height = (minY - maxY) * preview.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        
        preview.layer.addSublayer(outline)
    }
}
