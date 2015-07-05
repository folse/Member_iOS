//
//  Login.swift
//  member
//
//  Created by Jennifer on 7/1/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Login: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(sender: UIBarButtonItem) {
        
        login(emailTextField.text, password: passwordTextField.text)
        
    }
    
    func login(username:String,password:String) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        let url = API_ROOT + "login"
        println(url)
        let params:NSDictionary = ["username":username,"password":password]
        
        println(params)
        
        manager.GET(url,
            parameters: params as [NSObject : AnyObject],
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                
                println(responseObject.description)
                
                indicator.stopAnimating()
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let shopId = responseDict["shop_id"] as! String
                
                NSUserDefaults.standardUserDefaults().setObject(shopId, forKey: "shopId")
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLogined")
                                
                self.dismissViewControllerAnimated(true, completion: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                
                indicator.stopAnimating()
                println(error.localizedDescription)
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
