//
//  Utils.swift
//  FlickrGallery
//
//  Created by 管 皓 on 2018/4/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    /*
     Convert Date to string in 'YYYY-MM-dd' format inorder to pull out data with flickr API.
    */
    static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: date)
    }
    
    /*
     Convert hexString to UIColor. Usually I use 'colorhunt.co' to find appropriate color.
    */
    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
