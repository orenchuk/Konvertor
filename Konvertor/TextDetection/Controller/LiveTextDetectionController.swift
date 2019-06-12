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
import TesseractOCR

final class LiveTextDetectionController: NSObject {
    
    // MARK: Properties
    
    let preview: UIView
    var requests = [VNRequest]()
    var image: UIImage?
    weak var delegate: Recognizable?
    private let tesseract = G8Tesseract(language: "eng")
    
    init(preview: UIView) {
        self.preview = preview
        if tesseract == nil { fatalError() }
        tesseract?.engineMode = .tesseractOnly
        tesseract?.pageSegmentationMode = .singleBlock
        tesseract?.charBlacklist = "abcdefghilmnopqrstuvzABCDEFGHILMNOPQRSTUVZ \n,"
        tesseract?.charWhitelist = "01234567890."
    }
    
    // MARK: Methods
    
    func startTextDetection() {
        let textRectanglesRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRectanglesRequest.reportCharacterBoxes = true
        
        self.requests = [textRectanglesRequest]
    }
    
    private func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNTextObservation] else {
            fatalError("unexpected result type from VNDetectRectanglesRequest")
        }
        
        let result = observations.filter { $0.confidence > 0.9 }
        
        DispatchQueue.main.async() { [weak self] in
            guard let layer = self?.preview.layer else { return }
            layer.sublayers?.removeSubrange(1...)
            
            guard let img = self?.image else { fatalError("image is nil") }
            guard let tesseract = self?.tesseract else { fatalError("tesseract is nil") }
            
            for region in result {
                if let normalisedRect = self?.normalise(box: region) {
                    self?.drawBox(rect: normalisedRect)
                    
                    guard let cropped = self?.cropImage(image: img, normalisedRect: normalisedRect) else { fatalError("cropped image is nil") }
                    
                    tesseract.image = cropped
                    tesseract.recognize()
                    self?.delegate?.didFinishWithResult(tesseract.recognizedText)
                }

                if let boxes = region.characterBoxes {
                    for box in boxes {
                        self?.highlightLetters(box: box)
                    }
                }
            }
        }
    }
    
    private func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * preview.frame.size.width
        let yCord = (1 - box.topLeft.y) * preview.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * preview.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * preview.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        preview.layer.addSublayer(outline)
    }
    
    private func drawBox(rect: CGRect, color: UIColor = .red) {
        let x = rect.origin.x * preview.layer.frame.size.width
        let y = rect.origin.y * preview.layer.frame.size.height
        let width = rect.width * preview.layer.frame.size.width
        let height = rect.height * preview.layer.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: x, y: y, width: width, height: height).scaleUp(scaleUp: 0.1)
        outline.borderWidth = 1.0
        outline.borderColor = color.cgColor
        
        preview.layer.addSublayer(outline)
    }
    
    private func normalise(box: VNTextObservation) -> CGRect {
        return CGRect(
            x: box.boundingBox.origin.x,
            y: 1 - box.boundingBox.origin.y - box.boundingBox.height,
            width: box.boundingBox.size.width,
            height: box.boundingBox.size.height
        )
    }
    
    private func cropImage(image: UIImage, normalisedRect: CGRect) -> UIImage? {
        let x = normalisedRect.origin.x * image.size.width
        let y = normalisedRect.origin.y * image.size.height
        let width = normalisedRect.width * image.size.width
        let height = normalisedRect.height * image.size.height
        
        let rect = CGRect(x: x, y: y, width: width, height: height).scaleUp(scaleUp: 0.1)
        
        guard let cropped = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        
        let croppedImage = UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
        return croppedImage
    }
    
}
