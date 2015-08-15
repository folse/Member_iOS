//
//  MemberList.swift
//  member
//
//  Created by Jennifer on 7/13/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class MemberList: UITableViewController {
    
    var membersArray : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clearColor()
        
        getMerchantInfo()
    }
    
    func getMerchantInfo() {
        
        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        
        let url = API_ROOT + "shop"
        println(url)
        
        let shopId : String = NSUserDefaults.standardUserDefaults().objectForKey("shopId") as! String
        
        let params:NSDictionary = ["shop_id":shopId]
        
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
                    
                    self.membersArray = data["members"] as! NSArray
                    
                    self.tableView.reloadData()
                    
                    self.tableView.separatorColor = UIColor.lightGrayColor()
                    
                    self.title = "\(self.membersArray.count)  Kundmedlemar"
                    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let member : Dictionary = membersArray[indexPath.row] as! Dictionary<String,AnyObject>
        
        let vaild_quantity = member["vaild_quantity"] as! Int
        let punched_quantity = member["punched_quantity"] as! Int
        
        cell.textLabel?.text = member["username"] as? String
        cell.detailTextLabel?.text = "Köpt : \(vaild_quantity)     Poäng : \(punched_quantity)"
        
        cell.textLabel?.font = UIFont.systemFontOfSize(28)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(22)

        cell.detailTextLabel?.textColor = UIColor.grayColor()
        
        return cell
    }
    

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
