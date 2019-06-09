//
//  CameraCaptureViewController.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

class CameraCaptureViewController: UIViewController {
    
    // MARK: Properties
    
    private var cameraController: CameraCaptureController!
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var preview: UIView!
    @IBOutlet private weak var captureButtonOutlet: UIButton!
    
    // MARK: IBActions
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
        cameraController.session.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController = CameraCaptureController(preview: preview)
        cameraController.configureSession()
        
        if let layer = cameraController.previewLayer {
            layer.position = view.layer.position
            layer.frame = view.frame
            preview.layer.addSublayer(layer)
            cameraController.session.startRunning()
        } else {
            print("Camera layer wasn't set yet")
        }
        
    }
    
}
