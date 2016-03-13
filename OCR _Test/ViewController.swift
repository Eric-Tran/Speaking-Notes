//
//  ViewController.swift
//  OCR _Test
//
//  Created by yanze on 1/15/16.
//  Copyright © 2016 River Inn Technology. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, G8TesseractDelegate, CancelButtonDelegate{
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var messageFrame = UIView()
    
    // loading gif
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)

    }
    
    func hideLoading(){
        messageFrame.removeFromSuperview()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
            
                

//                previewLayer!.connection?.videoOrientation = returnOrientation()
                
                previewView.layer.addSublayer(previewLayer!)
              
                captureSession!.startRunning()
            }
        }
    }
    
    
    
//    func returnOrientation() -> AVCaptureVideoOrientation{
//        var videoOrientation: AVCaptureVideoOrientation!
//        let orientation = UIDevice.currentDevice().orientation
//        
//        switch orientation{
//            case .Portrait:
//                videoOrientation = .Portrait
//            case .PortraitUpsideDown:
//                videoOrientation = .PortraitUpsideDown
//            case .LandscapeLeft:
//                videoOrientation = .LandscapeLeft
//            case .LandscapeRight:
//                videoOrientation = .LandscapeRight
//            default:
//                videoOrientation = .Portrait
//            
//        }
//        return videoOrientation
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    @IBAction func didPressTakePhoto(sender: UIButton) {
        
        progressBarDisplayer("Processing", true)
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.capturedImage.image = image
                    
                    let tesseract:G8Tesseract = G8Tesseract(language:"eng");
                    //tesseract.language = "eng+ita";
                    tesseract.delegate = self;
                    // tesseract.charWhitelist = "01234567890";
                    tesseract.image = image.g8_blackAndWhite(); // add photo here to extract words
                    tesseract.recognize(); // find characters
                    NSLog("%@", tesseract.recognizedText);
                    self.hideLoading()
                    let newNote = Note(obj: tesseract.recognizedText)
                    newNote.save()
                }
            })
        }
    }
    
    
    @IBAction func didPressTakeAnother(sender: AnyObject) {
        captureSession!.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddNewNote" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! NotesViewController
            controller.cancelButtonDelegate = self
        }
    }

}

