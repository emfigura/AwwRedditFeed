//
//  ViewController.swift
//  AwwRedditFeed
//
//  Created by Eric on 10/21/15.
//  Copyright © 2015 Eric Figura. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
    }
}