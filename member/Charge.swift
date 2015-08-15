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
    
        var vaildQuantityInt : Int = 0

        @IBOutlet weak var quantityTextField: UITextField!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            quantityTextField.becomeFirstResponder()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        @IBAction func doneButtonAction(sender: UIBarButtonItem) {
            
            self.view.endEditing(true)
            
            charge(customerUsername, quantity : quantityTextField.text)
        }
        
        func charge(username:String,quantity:String) {
            
            var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
            
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
                    
                    WIndicator.removeIndicatorFrom(self.view, animation: true)
                    
                    let responseDict = responseObject as! Dictionary<String,AnyObject>
                    let responseCode = responseDict["resp"] as! String
                    if responseCode == "0000"{
                        
                        let data = responseObject["data"] as! Dictionary<String,AnyObject>
                        
                        self.vaildQuantityInt = data["vaild_quantity"]  as! Int
                        
                        var indicator = WIndicator.showSuccessInView(self.view, text:"      ", timeOut:1)
                        
                        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "dismissView", userInfo: nil, repeats: false)
                        
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
                    
                    WIndicator.removeIndicatorFrom(self.view, animation: true)
                    
                    let alert = UIAlertView()
                    alert.title = "Denna operation kan inte slutföras"
                    alert.message = "Försök igen eller kontakta vår kundtjänst. För bättre och snabbare service, rekommenderar vi att du skickar oss en skärmdump." + error.localizedDescription + "\(error.code)"
                    alert.addButtonWithTitle("OK")
                    alert.show()
            })
        }
    
        func dismissView() {
            
            NSNotificationCenter.defaultCenter().postNotificationName("updateVaildQuantity", object:self.vaildQuantityInt)
            
            self.navigationController?.popViewControllerAnimated(true)
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

