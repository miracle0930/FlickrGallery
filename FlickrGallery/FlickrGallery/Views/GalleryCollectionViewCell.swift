//
//  GalleryCollectionViewCell.swift
//  FlickrGallery
//
//  Created by 管 皓 on 2018/4/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import UIKit

//private let kScreenWidth = UIScreen.main.bounds.width

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        titleLabel.font = UIFont(name: "Chalkboard SE", size: 17)
        titleLabel.backgroundColor = .clear
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        photoImageView.contentMode = .scaleAspectFill
    }

}
