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
        
        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        
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
                
                WIndicator.removeIndicatorFrom(self.view, animation: true)
                
                let responseDict = responseObject as! Dictionary<String,AnyObject>
                
                let respCode = responseDict["resp"] as! String
                
                if respCode == "0000" {
                    
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
        self.navigationController?.popToRootViewControllerAnimated(true)
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
