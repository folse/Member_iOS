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
        
        if quantityTextField.text.length == 0 {
            
            registerCustomer(phoneTextField.text, realName: realNameTextField.text, quantity:"0")
            
        }else{
            
            registerCustomer(phoneTextField.text, realName: realNameTextField.text, quantity:quantityTextField.text)
        }
    }
    
    func registerCustomer(username:String,realName:String,quantity:String) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
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
                
                indicator.stopAnimating()
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let responseCode = responseDict["resp"] as! String
                
                if responseCode == "0000" {
                    
                    let alert = UIAlertView()
                    alert.title = "Success"
                    alert.message = "Nu har du en ny medlem"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    
                    self.performSegueWithIdentifier("trade", sender: self)
                    
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
           
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "trade"{
            
            var segue = segue.destinationViewController as! Trade
            segue.customerUsername = phoneTextField.text
            segue.vaildQuantity = quantityTextField.text
            segue.punchedQuantity = "0"
        }
    }
}
