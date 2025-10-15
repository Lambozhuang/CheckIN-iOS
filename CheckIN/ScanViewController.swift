//
//  ScanViewController.swift
//  CheckIN
//
//  Created by Lambo.T.Zhuang on 2021/3/24.
//

import UIKit
import AVFoundation

protocol ScanViewControllerDelegate: AnyObject {
    
    func ScanDidFinish(_ scanViewController: ScanViewController)
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAdaptivePresentationControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var scanString: String = ""
    
    weak var delegate: ScanViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(
            title: L10n.Alert.cameraNotSupportedTitle,
            message: L10n.Alert.cameraNotSupportedMessage,
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: L10n.Alert.ok, style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.scanString = stringValue
            delegate?.ScanDidFinish(self)
        }

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func selectFromLibrary(_ sender: Any) {
        
        self.captureSession.stopRunning()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("ERROR")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        picker.dismiss(animated: true)
        
        //二维码读取
        let ciImage:CIImage=CIImage(image:image)!
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        if let features = detector?.features(in: ciImage) {
            if features.count > 0 {
                let feature: CIQRCodeFeature = features[0] as! CIQRCodeFeature
                self.scanString = feature.messageString ?? "NULL"
                delegate?.ScanDidFinish(self)
            } else {
                self.scanString = "NO-QRCODE"
                delegate?.ScanDidFinish(self)
            }
            
        }
        
        
    }
    
    
    func showContinueNotice(strArray: [String]) {
        
        let alertCotroller = UIAlertController(
            title: L10n.Alert.checkinSuccessTitle(strArray[1]),
            message: L10n.Alert.checkinSuccessMessage(strArray[4]),
            preferredStyle: .alert
        )

        // Create the actions.
        let cancelAction = UIAlertAction(title: L10n.Button.cancel, style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        let continueAction = UIAlertAction(title: L10n.Alert.continue_, style: .default) { _ in
            self.captureSession.startRunning()
            
        }
        
        // Add the actions.
        alertCotroller.addAction(cancelAction)
        alertCotroller.addAction(continueAction)

        present(alertCotroller, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: message,
            message: "",
            preferredStyle: .alert
        )

        // Create the action.
        let cancelAction = UIAlertAction(title: L10n.Alert.confirm, style: .cancel) { _ in
            self.captureSession.startRunning()
        }

        // Add the action.
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
}
