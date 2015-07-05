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
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        }
        */
        
}

