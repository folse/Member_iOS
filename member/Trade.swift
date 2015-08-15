//
//  Trade.swift
//  member
//
//  Created by Jennifer on 7/1/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Trade: UITableViewController {
    
    var realName : String = ""
    
    var vaildQuantity : String = ""
    
    var punchedQuantity : String = ""
    
    var customerUsername : String = ""
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var vaildQuantityLabel: UILabel!
    
    @IBOutlet weak var punchedQuantityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = realName
        vaildQuantityLabel.text = vaildQuantity
        punchedQuantityLabel.text = punchedQuantity
        
        NSNotificationCenter.defaultCenter().addObserverForName("updateVaildQuantity", object:nil, queue:NSOperationQueue.mainQueue(), usingBlock:{notification in
            
            let newVaildQuantity = notification.object as! Int
            
            println(newVaildQuantity)
            
            self.vaildQuantity = "\(newVaildQuantity)"
            
            self.vaildQuantityLabel.text = self.vaildQuantity
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName("updatePunchedQuantity", object:nil, queue:NSOperationQueue.mainQueue(), usingBlock:{notification in
            
            let newPunchedQuantity = notification.object as! Int
            
            println(newPunchedQuantity)
            
            self.punchedQuantity = "\(newPunchedQuantity)"
            
            self.punchedQuantityLabel.text = self.punchedQuantity
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func memberTradeButtonAction(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if quantityTextField.text.length == 0 {
            
            trade(customerUsername, quantity : "1")
            
        }else{
            
            trade(customerUsername, quantity : quantityTextField.text)
        }
    }
    
    func trade(username:String,quantity:String) {
        
        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        
        let url = API_ROOT + "trade_add"
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
                    
                    var orderQuantity = quantity.toInt()!
                    
                    var vaildQuantityInt = self.vaildQuantity.toInt()! - orderQuantity
                    
                    self.vaildQuantity  = "\(vaildQuantityInt)"
                    
                    self.vaildQuantityLabel.text = self.vaildQuantity
                    self.punchedQuantityLabel.text = self.punchedQuantity
                    
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "punch"{
            
            var segue = segue.destinationViewController as! Punch
            segue.punchedQuantity = self.punchedQuantity.toInt()!
            segue.customerUsername = self.customerUsername
            
        }else if segue.identifier == "charge"{
            
            var segue = segue.destinationViewController as! Charge
            segue.customerUsername = self.customerUsername
        }
    }
}

extension String {
    var length: Int { return count(self)         }  // Swift 1.2
}
