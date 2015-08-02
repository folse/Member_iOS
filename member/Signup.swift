//
//  Signup.swift
//  member
//
//  Created by Jennifer on 7/1/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit


class Signup: UITableViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var realNameTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneTextField.text = ""
        realNameTextField.text = ""
        quantityTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DoneButtonAction(sender: UIBarButtonItem) {

        if phoneTextField.text.length != 0 && realNameTextField.text.length != 0 {
            
            self.view.endEditing(true)
            
            if quantityTextField.text.length == 0 {
                
                registerCustomer(phoneTextField.text, realName: realNameTextField.text, quantity:"0")
                
            }else{
                
                registerCustomer(phoneTextField.text, realName: realNameTextField.text, quantity:quantityTextField.text)
            }
        }
    }
    
    func registerCustomer(username:String,realName:String,quantity:String) {
        
        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        
        let url = API_ROOT + "membership_new"
        println(url)
        
        let shopId : String = NSUserDefaults.standardUserDefaults().objectForKey("shopId") as! String
        
        let params:NSDictionary = ["customer_username":username,
            "real_name":realName,
            "shop_id":shopId,
            "phone":username,
            "email":"",
            "quantity":quantity]
        
        println(params)
        
        manager.GET(url,
            parameters: params as [NSObject : AnyObject],
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                
                println(responseObject.description)
                
                WIndicator.removeIndicatorFrom(self.view, animation: true)
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let responseCode = responseDict["resp"] as! String
                
                if responseCode == "0000" {
                    
                    var indicator = WIndicator.showSuccessInView(self.view, text:"      ", timeOut:1)
                    
                    var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "nextPage", userInfo: nil, repeats: false)
                    
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
    
    func nextPage() {
        self.performSegueWithIdentifier("trade", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "trade"{
            
            var segue = segue.destinationViewController as! Trade
            segue.realName = realNameTextField.text
            segue.customerUsername = phoneTextField.text
            
            if quantityTextField.text.length > 0 {
                segue.vaildQuantity = quantityTextField.text
            }else{
                segue.vaildQuantity = "0"
            }
            
            segue.punchedQuantity = "0"
        }
    }
}
