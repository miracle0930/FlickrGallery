//
//  FlickrAPIParser.swift
//  FlickrGallery
//
//  Created by 管 皓 on 2018/4/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash


class FlickrAPIParser {
    
    private let baseAPI = "https://api.flickr.com/services/rest/?method="
    
    /*
     Built 'flickr.interestingness.getList' api with date, page, per_page variables.
     Used Alamofire to send request and SWXMLHash to parse the response data.
     Once complete gathering all data in current page, completion handler will be called to send data back to `GalleryCollectionViewController`.
    */
    func getInterestingnessList(key: String, date: String, page: Int, per_page: Int, completion: @escaping(_ result: [Photo]?, _ error: String?) -> Void) {
        let requestURL = "\(baseAPI)flickr.interestingness.getList&date=\(date)&per_page=\(per_page)&page=\(page)&api_key=\(key)"
        var photos = [Photo]()
        Alamofire.request(requestURL, method: .get).responseData { (response) in
            if response.result.isSuccess {
                let data = SWXMLHash.parse(response.data!)
                // If we have reached to the last page, there is no need to load them again.
                if page > Int((data["rsp"]["photos"].element?.attribute(by: "page")?.text)!)! {
                    return
                }
                for i in stride(from: 0, to: data["rsp"]["photos"]["photo"].all.count, by: 1) {
                    let photo = Photo()
                    photo.id = (data["rsp"]["photos"]["photo"][i].element?.attribute(by: "id")?.text)!
                    photo.farm = (data["rsp"]["photos"]["photo"][i].element?.attribute(by: "farm")?.text)!
                    photo.server = (data["rsp"]["photos"]["photo"][i].element?.attribute(by: "server")?.text)!
                    photo.secret = (data["rsp"]["photos"]["photo"][i].element?.attribute(by: "secret")?.text)!
                    photo.photoTitle = (data["rsp"]["photos"]["photo"][i].element?.attribute(by: "title")?.text)!
                    photos.append(photo)
                }
                completion(photos, nil)
            } else {
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    /*
     Built 'flicker.photos.getInfo' api with photoID.
     Used Alamofire to send request and SWXMLHash to pares the response data.
     Once complete, completion handler will be called to send data back to `PhotoViewController`.
    */
    func getPhotoInfo(key: String, photoID: String, completion: @escaping (_ detail: [String: String]) -> Void) {
        let requestURL = "\(baseAPI)flickr.photos.getInfo&photo_id=\(photoID)&api_key=\(key)"
        Alamofire.request(requestURL, method: .get).responseData { (response) in
            if response.result.isSuccess {
                let data = SWXMLHash.parse(response.data!)
                var photoInfo: [String: String] = [:]
                photoInfo["author"] = data["rsp"]["photo"]["owner"].element?.attribute(by: "realname")?.text
                photoInfo["description"] = data["rsp"]["photo"]["description"].element?.text
                photoInfo["recordDate"] = data["rsp"]["photo"]["dates"].element?.attribute(by: "taken")?.text
                completion(photoInfo)
            }
        }
    }
    
}
