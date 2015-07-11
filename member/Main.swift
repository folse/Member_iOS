//
//  Main.swift
//  member
//
//  Created by Jennifer on 7/1/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Main: UITableViewController {
    
    var usedQuantity : String = ""
    
    var vaildQuantity : String = ""
    
    var punchedQuantity : String = ""

    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLogined : Bool = NSUserDefaults.standardUserDefaults().boolForKey("isLogined")
        
        if isLogined {
            phoneTextField.becomeFirstResponder()
        }else {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    @IBAction func tradeButtonAction(sender: UIBarButtonItem) {
        
        getCustomerInfo(phoneTextField.text)
    }
    
    func getCustomerInfo(username:String) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
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
                
                indicator.stopAnimating()
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let respCode = responseDict["resp"] as! String
                
                if respCode == "0000" {
                    
                    let data = responseObject["data"] as! Dictionary<String,AnyObject>
                    
                    let usedQuantityInt = data["used_quantity"]  as! Int
                    let vaildQuantityInt = data["vaild_quantity"]  as! Int
                    let punchedQuantityInt = data["punched_quantity"] as! Int
                    
                    self.usedQuantity  = "\(usedQuantityInt)"
                    self.vaildQuantity  = "\(vaildQuantityInt)"
                    self.punchedQuantity  = "\(punchedQuantityInt)"
                    
                    self.performSegueWithIdentifier("trade", sender: self)
                    
                }else {
                    
                    let message = responseDict["msg"] as! String
                    
                    let alert = UIAlertView()
                    alert.title = "Faild"
                    alert.message = message
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                
                indicator.stopAnimating()
                
                let alert = UIAlertView()
                alert.title = "Faild"
                alert.message = error.localizedDescription
                alert.addButtonWithTitle("OK")
                alert.show()
        })
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
            segue.usedQuantity = self.usedQuantity
            segue.vaildQuantity = self.vaildQuantity
            segue.punchedQuantity = self.punchedQuantity
            segue.customerUsername = phoneTextField.text
        }
    }
}