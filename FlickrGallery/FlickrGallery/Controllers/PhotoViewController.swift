//
//  PhotoViewController.swift
//  FlickrGallery
//
//  Created by 管 皓 on 2018/4/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var flickrAPIParser: FlickrAPIParser?
    var photoId: String?
    var imageData: Data?
    var photoTitle: String?
    
    // use label placeholders if corresponding items were found empty.
    let authorPlaceholder = "Unknown"
    let titlePlaceholder = "Unnamed"
    let recordDatePlaceHolder = "Some day in the past."
    let descriptionPlaceholder = "The author was too lazy to leave a description."
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var recordDateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        view.backgroundColor = Utils.hexStringToUIColor(hex: "#FBF2D5")
        photoImageView.image = UIImage(data: imageData!)
        photoImageView.contentMode = .scaleAspectFit
        photoTitleLabel.text = photoTitle!
        loadPhotoInfo()
    }
    
    // use flickrAPIParser to load the photo's detail.
    func loadPhotoInfo() {
        flickrAPIParser?.getPhotoInfo(key: api_key, photoID: photoId!, completion: { (info, error) in
            if let info = info {
                self.authorLabel.text = info["author"] == "" ? self.authorPlaceholder : info["author"]
                self.recordDateLabel.text = info["recordDate"] == "" ? self.recordDatePlaceHolder : info["recordDate"]
                self.photoDescriptionTextView.text = info["description"] == "" ? self.descriptionPlaceholder : info["description"]
            } else {
                let alert = UIAlertController(title: "Failed", message: error!, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
