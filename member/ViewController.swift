//
//  ViewController.swift
//  member
//
//  Created by Jennifer on 6/29/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateWeatherInfo() {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        println(url)
        let params:NSDictionary = ["lat":"37.785834", "lon":"-122.406417", "cnt":0]
        println(params)
        manager.GET(url,
            parameters: params as [NSObject : AnyObject],
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
//                Log(responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
//                self.weatherInfo.text = "Error: " + error.localizedDescription
                
        })
    }

}

