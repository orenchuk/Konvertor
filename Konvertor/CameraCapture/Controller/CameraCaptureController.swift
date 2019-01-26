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

class CameraCaptureController: NSObject {
    
    // MARK: Properties
    
    var preview: UIView?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let session = AVCaptureSession()
    private let liveTextDetection: LiveTextDetectionController?
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput")
    
    override init() {
        self.preview = nil
        self.liveTextDetection = nil
    }
    
    init(preview: UIView) {
        self.preview = preview
        self.liveTextDetection = LiveTextDetectionController(preview: preview)
        self.liveTextDetection?.startTextDetection()
    }
    
    // MARK: Public methods
    
    func checkPermission(completion: @escaping (Bool?) -> ()){
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
    
    func changePermission(viewController vc: UIViewController) {
        let alertController = UIAlertController(title: "Please change privacy settings", message: "No permission to use camera", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func configureSession() {
        
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
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        if session.canAddOutput(videoDataOutput) {
            
            // Add a video data output
            
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            
            session.addOutput(videoDataOutput)
            
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        session.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
}

extension CameraCaptureController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let liveTextDetection = liveTextDetection {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            var requestOptions: [VNImageOption : Any] = [:]
            
            if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
                requestOptions = [.cameraIntrinsics:camData]
            }
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: requestOptions)
            
            do {
                try imageRequestHandler.perform(liveTextDetection.requests)
            } catch {
                print(error)
            }
        } else {
            print("TextDetect is nill")
        }
        
    }
    
}
