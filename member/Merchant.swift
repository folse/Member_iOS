//
//  Merchant.swift
//  member
//
//  Created by Jennifer on 7/10/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Merchant: UITableViewController {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var memberCountLabel: UILabel!
    
    var promotionString : String = ""
    
    var membersArray : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getMerchantInfo()
    }
    
    func getMerchantInfo() {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
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
                
                indicator.stopAnimating()
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let respCode = responseDict["resp"] as! String
                
                if respCode == "0000" {
                    
                    let data = responseObject["data"] as! Dictionary<String,AnyObject>
                    
                    self.membersArray = data["members"] as! NSArray
                    
                    var promotion = data["promotion"] as! String
 
                    self.promotionString = promotion
                    
                    self.shopNameLabel.text  = data["name"] as? String
                    self.memberCountLabel.text  = "\(self.membersArray.count)"
                    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "promotion"{
            
            var segue = segue.destinationViewController as! Promotion
            segue.promotionString = self.promotionString
            
        }else if segue.identifier == "member"{
            
            var segue = segue.destinationViewController as! Member
            segue.membersArray = self.membersArray
        }
    }
}
