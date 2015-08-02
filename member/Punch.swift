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
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("updatePunchedQuantity", object: punchedQuantity)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Poäng " + "\(punchedQuantity)" + "/20"
        
        if punchedQuantity == 20{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Starta om", style: UIBarButtonItemStyle.Done, target:self, action: Selector(punchReset()))
        }
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        var controllerArray : Array<AnyObject>! = self.navigationController?.viewControllers
        
        let lastControllerId : Int = controllerArray.count - 2
        
        controllerArray.removeAtIndex(lastControllerId)
        
        self.navigationController?.viewControllers = controllerArray;
        
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func resetButtonAction(sender: AnyObject) {
        
        punchReset()
    }
    
    func punchReset() {
        
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
        
        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        
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
                
                WIndicator.removeIndicatorFrom(self.view, animation: true)
                
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
