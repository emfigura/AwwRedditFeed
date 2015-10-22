//
//  AwwService.swift
//  AwwRedditFeed
//
//  Created by Eric on 10/20/15.
//  Copyright © 2015 Eric Figura. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol AwwServiceDelegate: class {
    func awwServiceSuccess(models: [AwwServiceModel])
    func awwServiceFailure()
}

class AwwService {
    
    weak var delegate: AwwServiceDelegate?
    
    /**
    The call to retrieve data
    
    - parameter limit:    The amount of data to retrieve
    - parameter lastName: The name of the last item retrieve. Used for Pagination.
    */
    func getData(limit: String, lastName: String?) {
        //Creates the url and sets the limit
        var url = "https://www.reddit.com/r/aww/.json?limit=\(limit)"
        if let lastName = lastName {
            url += "&after=\(lastName)"
        }
    
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            if response.result.error != nil {
                self.delegate?.awwServiceFailure()
            } else {
                if let responseAsJson = response.result.value {
                    self.delegate?.awwServiceSuccess(self.awwServiceJsonParser(JSON(responseAsJson)))
                }
            }
        }
    
    }
    
    //See json response at https://www.reddit.com/r/aww/.json
    private func awwServiceJsonParser(initialJson: JSON) -> [AwwServiceModel] {
        
        var models:[AwwServiceModel] = []
        let children = initialJson["data"]["children"]
        
        for (key: _, subJson: childJSON) in children {
            let dataForChild = childJSON["data"]
            let createdDate = dataForChild["created"].double
            let author = dataForChild["author"].string
            let title = dataForChild["title"].string
            let preview = dataForChild["preview"].dictionary
            let score = dataForChild["score"].int
            let name = dataForChild["name"].string
            let shareURL = dataForChild["url"].string
            var imageURL: String? = nil
            if let preview = preview, images = preview["images"]?.array, firstImage = images.first {
                imageURL = firstImage["source"]["url"].string
                print(imageURL)
            }
            if let author = author,
                   title = title,
                   imageURL = imageURL,
                   createdDate = createdDate,
                   score = score, name = name,
                   shareURL = shareURL {
                
                models.append(AwwServiceModel(author: author,imageURL: imageURL, title: title, created: createdDate, score: score, name: name, shareURL: shareURL))
            }
            
        }
        
        return models
    }
    
    
}