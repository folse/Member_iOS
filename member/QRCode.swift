//
//  ViewController.swift
//  TwoD_Code_Demo
//
//  Created by Techsun on 14-7-28.
//  Copyright (c) 2014年 techsun. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class QRCode: UIViewController ,AVCaptureMetadataOutputObjectsDelegate {

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGrayColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func setupCamera(){
        
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if (error != nil) {
            println(error!.description)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(20,150,280,280);
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        var stringValue:String!
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        
        println("code is \(stringValue)")
        
        self.navigationController?.popViewControllerAnimated(true)
        
        NSNotificationCenter.defaultCenter().postNotificationName("afterScanCustomer", object: stringValue)

//        var alertView = UIAlertView()
//        alertView.delegate=self
//        alertView.title = ""
//        alertView.message = "\(stringValue)"
//        alertView.addButtonWithTitle("确认")
//        alertView.show()
    }
}