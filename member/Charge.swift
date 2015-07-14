//
//  Charge.swift
//  member
//
//  Created by Jennifer on 7/2/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Charge: UITableViewController {
        
        var chargeQuantity : String = ""
    
        var customerUsername : String = ""
    
        @IBOutlet weak var phoneTextField: UITextField!

        @IBOutlet weak var quantityTextField: UITextField!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            phoneTextField.becomeFirstResponder()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        @IBAction func doneButtonAction(sender: UIBarButtonItem) {
            
            charge(phoneTextField.text, quantity : quantityTextField.text)
        }
        
        func charge(username:String,quantity:String) {
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.startAnimating()
            
            
            let manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
            let url = API_ROOT + "order_add"
            println(url)
            
            let shopId : String = NSUserDefaults.standardUserDefaults().objectForKey("shopId") as! String
            
            let params:NSDictionary = ["customer_username":username,
                "shop_id":shopId,
                "quantity":quantity,
                "trade_type":"1"]
            
            println(params)
            
            manager.GET(url,
                parameters: params as [NSObject : AnyObject],
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    
                    println(responseObject.description)
                    
                    indicator.stopAnimating()
                    
                    let responseDict = responseObject as! Dictionary<String,AnyObject>
                    let responseCode = responseDict["resp"] as! String
                    if responseCode == "0000"{
                    
                        let alert = UIAlertView()
                        alert.title = "Success"
                        alert.message = ""
                        alert.addButtonWithTitle("OK")
                        alert.show()
                    
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }else {
                        
                        let message = responseDict["msg"] as! String
                        
                        let alert = UIAlertView()
                        alert.title = "Denna operation kan inte slutföras"
                        alert.message = message
                        alert.addButtonWithTitle("OK")
                        alert.show()
                    }
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    
                    indicator.stopAnimating()
                    
                    let alert = UIAlertView()
                    alert.title = "Denna operation kan inte slutföras"
                    alert.message = "Försök igen eller kontakta vår kundtjänst. För bättre och snabbare service, rekommenderar vi att du skickar oss en skärmdump." + error.localizedDescription + "\(error.code)"
                    alert.addButtonWithTitle("OK")
                    alert.show()
            })
        }
           
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        }
        */
        
}

