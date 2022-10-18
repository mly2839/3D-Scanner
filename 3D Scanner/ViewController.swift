//
//  ViewController.swift
//  3D Scanner
//
//  Created by Michael Ly on 10/18/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // Things to do:
    
    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Shutter Button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.layer.cornerRadius = 100
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        checkCameraPermissions()
    }

    // function that checks for the camera persmissions
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    // function that sets up the camera
    private func setUpCamera() {
        // if you can find the device, input and output, add it to the session then run it
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }
}

