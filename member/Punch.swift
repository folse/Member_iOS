//
//  Punch.swift
//  grid
//
//  Created by Jennifer on 7/12/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class Punch: UICollectionViewController {
    
    var punchedQuantity : Int = 0
    var customerUsername : String = ""
    
    var punchedImage = UIImage(named: "logo")
    var grayImage = UIImage(named: "logo_gray")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stämplat " + "\(punchedQuantity)" + "/20"
    }
    
    @IBAction func punchResetButtonAction(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Är du säker?", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Nej", style: UIAlertActionStyle.Default,handler:nil))
        alertController.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default,handler: {
            
            (action: UIAlertAction!) in
            self.punch(self.customerUsername,isReset:true)
            
        }))

        self.presentViewController(alertController, animated:true, completion: nil)
    }
    
    func punch(username:String, isReset:Bool) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        
        var url:String = API_ROOT + "punch_add"
        println(url)
        
        if isReset {
            
            url = API_ROOT + "punch_reset"
            println(url)
        }
        
        let shopId : String = NSUserDefaults.standardUserDefaults().objectForKey("shopId") as! String
        
        let params:NSDictionary = ["shop_id":shopId,
            "customer_username":username,
            "trade_type":"2"]
        
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
                    
                    if isReset{
                        
                        self.punchedQuantity = 0
                        
                    }else{
                        
                        self.punchedQuantity += 1
                    }
                    
                    self.collectionView?.reloadData()
                    
                    self.title = "Stämplat " + "\(self.punchedQuantity)" + "/20"
                    
                    let alertController = UIAlertController(title: "Fungerar lyckat", message:
                        "", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {
                        
                        (action: UIAlertAction!) in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    }))
                    self.presentViewController(alertController, animated:true, completion: nil)
                    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PunchCell
        
        if indexPath.row < punchedQuantity {
            
            cell.imageView.image = punchedImage
            
        }else{
            
            cell.imageView.image = grayImage
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        println(indexPath.row)
        
        if indexPath.row >= punchedQuantity {

            punch(customerUsername,isReset:false)
        }
        
        return true
    }
    
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
