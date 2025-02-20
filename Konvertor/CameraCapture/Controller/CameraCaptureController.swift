//
//  CameraCaptureController.swift
//  Konvertor
//
//  Created by Yevhenii Orenchuk on 1/25/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

final class CameraCaptureController: NSObject {
    
    // MARK: Properties

    var previewLayer: AVCaptureVideoPreviewLayer?
    let session = AVCaptureSession()
    
    let liveTextDetection: LiveTextDetectionController?
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput")
    
    init(preview: UIView) {
        self.liveTextDetection = LiveTextDetectionController(preview: preview)
        self.liveTextDetection?.startTextDetection()
    }
    
    // MARK: Public methods
    
    static func checkPermission(completion: @escaping (Bool?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    completion(true)
                } else {
                    print("No permission")
                    completion(nil)
                }
            })
        default:
            print("There is no permission")
            completion(false)
        }
    }
    
    static func presentPermissionAlert(vc: UIViewController) {
        let alertController = UIAlertController(title: "Please change privacy settings", message: "No permission to use camera", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func configureSession() {
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        // Input
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            session.commitConfiguration()
            print("Device is not supported")
            return
        }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: captureDevice), session.canAddInput(videoDeviceInput) else {
            session.commitConfiguration()
            print("Couldn't add video device input to the session.")
            return
        }
        
        session.addInput(videoDeviceInput)
        
        // Output
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        if session.canAddOutput(videoDataOutput) {
            
            // Add a video data output
            
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.connection(with: AVMediaType.video)?.preferredVideoStabilizationMode = .off
            
            session.addOutput(videoDataOutput)
            
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        captureConnection?.videoOrientation = .portrait
        
        session.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
}

extension CameraCaptureController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let liveTextDetection = liveTextDetection else {
            fatalError("Error with liveTextDetection controller")
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            fatalError("Error with pixelBuffer")
        }
        
        var requestOptions: [VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: camData]
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let image = ciImage.toUIImage() else {
            fatalError("Can't convert CIImage to UIImage")
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: requestOptions)
        
        do {
            liveTextDetection.image = image
            try imageRequestHandler.perform(liveTextDetection.requests)
        } catch let error {
            print(error)
        }
        
    }
    
}
