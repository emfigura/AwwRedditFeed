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
    @IBOutlet private weak var imageTitle: UILabel!
    var imageUrl: String?
    var shareUrl: String?
    var pageTitle: String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        if let pageTitle = pageTitle {
            imageTitle.text = pageTitle
        } else {
            imageTitle.text = "Awww"
        }
        
        if let imageUrl = imageUrl {
            Alamofire.request(.GET, imageUrl).response { (request, response, data, error) -> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                if error != nil {
                    self.displayError("Error", message: "Something went wrong in the service!")
                } else {
                    if let data = data, image = UIImage(data: data) {
                        self.imageView.image = image
                    } else {
                        self.displayError("Error", message: "The service didn't return an image!")
                    }
                }
            }
        } else {
            self.displayError("Error", message: "The image url isn't correct!")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        }
        
    }

    @IBAction private func shareButtonTapped(sender: AnyObject) {
        if let shareUrl = shareUrl, shareUrlAsURL = NSURL(string: shareUrl) {
            let activityViewController = UIActivityViewController(activityItems: ["Look what I found on /r/aww!", shareUrlAsURL], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
            self.presentViewController(activityViewController, animated: true) {}
        }
        
    }
}
