//
//  Member.swift
//  member
//
//  Created by Jennifer on 7/1/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Member: UITableViewController {
    
    var realName : String = ""
    
    var usedQuantity : String = ""
    
    var vaildQuantity : String = ""
    
    var punchedQuantity : String = ""
    
    var customerUsername : String = ""

    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        phoneTextField.text = ""
        
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "showKeyboard", userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName("afterScanCustomer", object:nil, queue:NSOperationQueue.mainQueue(), usingBlock:{notification in
            
            self.customerUsername = notification.object as! String
            
            self.getCustomerInfo(self.customerUsername)
            
            self.view.endEditing(true)
        })
    }
    
    func showKeyboard(){
        
        self.phoneTextField.becomeFirstResponder()
    }
    
    @IBAction func tradeButtonAction(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        self.customerUsername = phoneTextField.text
        
        getCustomerInfo(self.customerUsername)
    }
    
    func getCustomerInfo(username:String) {
        
        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")

        let url = API_ROOT + "membership"
        println(url)
        
        let shopId : String = NSUserDefaults.standardUserDefaults().objectForKey("shopId") as! String
        
        let params:NSDictionary = ["shop_id":shopId,
                                   "customer_username":username]
        
        println(params)
        manager.GET(url,
            parameters: params as [NSObject : AnyObject],
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                
                println(responseObject.description)
                
                WIndicator.removeIndicatorFrom(self.view, animation: true)
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let respCode = responseDict["resp"] as! String
                
                if respCode == "0000" {
                    
                    let data = responseObject["data"] as! Dictionary<String,AnyObject>
                    
                    let realName = data["real_name"] as! String
                    let usedQuantityInt = data["used_quantity"]  as! Int
                    let vaildQuantityInt = data["vaild_quantity"]  as! Int
                    let punchedQuantityInt = data["punched_quantity"] as! Int
                    
                    self.realName = "\(realName)"
                    self.usedQuantity  = "\(usedQuantityInt)"
                    self.vaildQuantity  = "\(vaildQuantityInt)"
                    self.punchedQuantity  = "\(punchedQuantityInt)"
                    
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
                
                WIndicator.removeIndicatorFrom(self.view, animation: true)
                
                let alert = UIAlertView()
                alert.title = "Denna operation kan inte slutföras"
                alert.message = "Försök igen eller kontakta vår kundtjänst. För bättre och snabbare service, rekommenderar vi att du skickar oss en skärmdump." + error.localizedDescription + "\(error.code)"
                alert.addButtonWithTitle("OK")
                alert.show()
        })
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){1
//        
//        switch indexPath.row {
//            case 2:
//                self.performSegueWithIdentifier("signup", sender: self)
//            case 3:
//                self.performSegueWithIdentifier("charge", sender: self)
//            default:
//                println("")
//        }
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "trade"{
            
            var segue = segue.destinationViewController as! Trade
            segue.realName = self.realName
            segue.vaildQuantity = self.vaildQuantity
            segue.punchedQuantity = self.punchedQuantity
            segue.customerUsername = self.customerUsername
        }
    }
}