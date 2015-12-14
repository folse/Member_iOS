//
//  Settings.swift
//  member
//
//  Created by Jennifer on 12/15/15.
//  Copyright (c) 2015 Folse. All rights reserved.
//

import UIKit

class Settings: UITableViewController {

    @IBOutlet weak var switchButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var needSendPunchNotification:Bool = NSUserDefaults.standardUserDefaults().boolForKey("NEED_SEND_PUNCH_NOTIFICATION")
        switchButton.on = needSendPunchNotification
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func switchAction(sender: UISwitch) {
        
        NSUserDefaults.standardUserDefaults().setBool(switchButton.on, forKey: "NEED_SEND_PUNCH_NOTIFICATION")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
