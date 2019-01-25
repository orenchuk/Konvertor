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
    
    var rootLayer: CALayer! = nil
    
    private let session = AVCaptureSession()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput")
    
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private var permissionGranted = false
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var previewView: UIView!
    @IBOutlet private weak var captureButtonOutlet: UIButton!
    
    // MARK: IBActions
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
//        self.previewLayer.removeFromSuperlayer()
        self.previewLayer = nil
        self.session.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermission()
        configureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard self.permissionGranted else {
            print("No permision for camera")
            return
        }
        
        self.session.startRunning()
        
    }
    
    // MARK: Custom Methods
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    self.permissionGranted = true
                } else {
                    self.permissionGranted = false
                }
            })
        default:
            changePermission()
            print("There is no permission")
            permissionGranted = false
        }
    }
    
    private func configureSession() {
        
        guard permissionGranted else { return }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.
        
        // Input
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            session.commitConfiguration()
            print("Couldn't add video device input to the session.")
            return
        }
        
        session.addInput(videoDeviceInput)
        
        // Output

        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
//            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        
        session.commitConfiguration()
        
        previewView.layer.position = view.layer.position
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = previewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    private func changePermission() {
        let alertController = UIAlertController(title: "Please change privacy settings", message: "No permission to use camera", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
