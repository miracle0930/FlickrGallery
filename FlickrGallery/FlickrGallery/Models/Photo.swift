//
//  Photo.swift
//  FlickrGallery
//
//  Created by 管 皓 on 2018/4/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import Foundation

class Photo {
    
    // Variables to build full url to get static image from Flickr.
    var id = ""
    var farm = ""
    var server = ""
    var secret = ""
    
    var photoTitle = ""
    
    /*
     Built api to get static image from Flickr with photoId, farm, server and secret. 'photoImageURL' were lazy loaded when there is a need.
    */
    lazy var photoImageURL: String = {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }()
}
