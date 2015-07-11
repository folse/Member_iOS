//
//  Promotion.swift
//  member
//
//  Created by Jennifer on 7/11/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Promotion: UIViewController {
    
    var promotionString : String = ""
    
    @IBOutlet weak var promotionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.promotionTextView.text = promotionString
    }

    @IBAction func saveButtonAction(sender: AnyObject) {
        
        update_promotion(self.promotionTextView.text)
    }
    
    func update_promotion(promotion:String) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        
        var url:String = API_ROOT + "shop_promotion"
        println(url)
        
        let shopId : String = NSUserDefaults.standardUserDefaults().objectForKey("shopId") as! String
        
        let params:NSDictionary = ["shop_id":shopId,
                                   "promotion":promotion]
        
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
                    
                    let alert = UIAlertView()
                    alert.title = "Success"
                    alert.message = ""
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
