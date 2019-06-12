//
//  CameraCaptureViewController.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

protocol Recognizable: class {
    func didFinishWithResult(_ result: String?)
}

final class CameraCaptureVC: UIViewController {
    
    // MARK: Properties
    
    private var cameraController: CameraCaptureController!
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var preview: UIView!
    @IBOutlet private weak var captureButtonOutlet: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    
    var inputCurrency = "UAH"
    var outCurrency = "USD"
    var exangeRate: CurrentExchangeRate?
    
    // MARK: IBActions
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
        cameraController.session.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController = CameraCaptureController(preview: preview)
        cameraController.configureSession()
        cameraController.liveTextDetection?.delegate = self
        
        
        if let layer = cameraController.previewLayer {
            layer.frame = view.layer.frame
            preview.layer.addSublayer(layer)
            cameraController.session.startRunning()
        } else {
            print("Camera layer wasn't set yet")
        }
    }
    
}

extension CameraCaptureVC: Recognizable {
    func didFinishWithResult(_ result: String?) {
        if let str = result {
            self.resultLabel.text = str
        
            if let number = Double(str) {
                let value = Converter.convert(inputCurrency: inputCurrency, amount: number, outputCurrency: outCurrency, currency: exangeRate!)
                self.resultLabel.text = "\(number)\(inputCurrency) -> \(value)\(outCurrency)"
            } 
        }
    }
}
