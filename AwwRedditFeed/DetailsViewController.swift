//
//  DetailsViewController.swift
//  AwwRedditFeed
//
//  Created by Eric on 10/20/15.
//  Copyright © 2015 Eric Figura. All rights reserved.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    var url: String!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        Alamofire.request(.GET, url).response { (request, response, data, error) -> Void in
            self.activityIndicator.stopAnimating()
            if error != nil {
                let alertController = UIAlertController(title: "Error!", message:
                    "Something went wrong in the service!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                if let data = data, image = UIImage(data: data) {
                    self.imageView.image = image
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
