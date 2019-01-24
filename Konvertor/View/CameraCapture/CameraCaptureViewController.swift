//
//  CameraCaptureViewController.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: Properties
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue") // Communicate with the session and other session objects on this queue.
    private var permissionGranted = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButtonOutlet: UIButton!
    
    // MARK: IBActions
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
        sessionQueue.async { [unowned self] in
            self.session.stopRunning()
        }
    }
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewView.session = session
        
        sessionQueue.async { [unowned self] in
            self.checkPermission()
            self.configureSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async { [unowned self] in
            guard self.permissionGranted else {
                print("No permision for camera")
                return
            }
            
            self.session.startRunning()
        }
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
        
        guard permissionGranted else { return }
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        // Input
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            session.commitConfiguration()
            print("Couldn't add video device input to the session.")
            return
        }
        
        session.addInput(videoDeviceInput)
        
        // Output
        
        let output = AVCaptureVideoDataOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        
        output.setSampleBufferDelegate(self, queue: sessionQueue)
        output.alwaysDiscardsLateVideoFrames = true
        
        DispatchQueue.main.async { [unowned self] in

            let statusBarOrientation = UIApplication.shared.statusBarOrientation
            var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
            if statusBarOrientation != .unknown {
                if let videoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue) {
                    initialVideoOrientation = videoOrientation
                }
            }
            
            self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
            
            self.session.commitConfiguration()
        }
    }
}
