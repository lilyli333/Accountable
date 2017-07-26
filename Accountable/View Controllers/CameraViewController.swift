//
//  CameraViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/25/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

class CameraViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var task: Task?
    var items = [Item]()
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var cameraPreviewView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        takePhotoButton.layer.cornerRadius = 10
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            captureSession?.addOutput(capturePhotoOutput)
            
        } catch {
            print(error)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTapTakePhone(_ sender: Any) {
        
        guard let capturePhotoOutput = self.capturePhotoOutput else {
            performSegue(withIdentifier: "backToTimer", sender: self)
            print("no camera device found")
            return
        }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTimer" {
            let timerViewController = segue.destination as! TimerViewController
            timerViewController.task = task!
            timerViewController.items = items
            do{
                timerViewController.items.remove(at: 0)
                timerViewController.seconds = timerViewController.getTime()
            }
            catch{
                print(error)
            }
            
        }
        else if segue.identifier == "finishedTask" {
            let congratsViewConroller = segue.destination as! FinishTaskViewController
            congratsViewConroller.task = task!
        }
    }
    
    func sendText(image: UIImage) {
        if (MFMessageComposeViewController.canSendText() && MFMessageComposeViewController.canSendAttachments()) {
            let controller = MFMessageComposeViewController()
            controller.recipients = ["\(task!.phoneNumber)"]
            let imageData = UIImagePNGRepresentation(image)
            controller.addAttachmentData(imageData!, typeIdentifier: "public.data", filename: "image.png")
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("DEVICE CANNOT SEND MSG")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if items.count == 1{
            performSegue(withIdentifier: "finishedTask", sender: self)
        }
        else{
            performSegue(withIdentifier: "backToTimer", sender: self)
        }
        
    }
    
}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            sendText(image: image)
        }
    }
}
