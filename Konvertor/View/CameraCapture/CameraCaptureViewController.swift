//
//  CameraCaptureViewController.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureViewController: UIViewController {
    
    // MARK: Properties
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue") // Communicate with the session and other session objects on this queue.
    private var permissionGranted = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButtonOutlet: UIButton!
    
    // MARK: IBActions
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
    }
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Custom Methods
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    self.permissionGranted = true
                } else {
                    self.permissionGranted = false
                }
                self.sessionQueue.resume()
            })
        default:
            permissionGranted = false
        }
    }
    
    private func configureSession() {
        
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            session.commitConfiguration()
            print("Couldn't add video device input to the session.")
            return
        }
        
        session.addInput(videoDeviceInput)
        
    }
}
