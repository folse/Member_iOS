//
//  Main.swift
//  member
//
//  Created by Jennifer on 7/10/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Main: UITableViewController {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLogined : Bool = NSUserDefaults.standardUserDefaults().boolForKey("isLogined")
        
        if isLogined {
            
            let shopName : String = NSUserDefaults.standardUserDefaults().objectForKey("shopName") as! String
            
            self.shopNameLabel.text = shopName
            
        }else {
            
            self.performSegueWithIdentifier("login", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
