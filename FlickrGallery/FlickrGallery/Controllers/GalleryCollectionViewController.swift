//
//  GalleryCollectionViewController.swift
//  FlickrGallery
//
//  Created by 管 皓 on 2018/4/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

// get photo list api: https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&date=YYYY-MM-DD&api_key=97dfca9877ec3947b4d5e86960ed46ef
// get photo image api: https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&photo_id=XXXX&api_key=97dfca9877ec3947b4d5e86960ed46ef



import UIKit

let api_key = "97dfca9877ec3947b4d5e86960ed46ef"

// Use NSCache to store imageData into key-value pairs inorder to optimize the collectionView's performance.
var imageCache = NSCache<NSString, NSData>()

class GalleryCollectionViewController: UICollectionViewController {
    
    var photos = [Photo]()
    let flickrParser = FlickrAPIParser()
    var page = 1
    var per_page = 15

    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery"
        self.collectionView!.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "galleryCollectionViewCell")
        
        loadInterestingnessList()
    }
    
    // use flickrParser to get a list of photos which will be shown on collectionView.
    func loadInterestingnessList() {
        flickrParser.getInterestingnessList(key: api_key, date: Utils.dateToString(date: yesterday), page: page, per_page: per_page) { (photos) in
            self.photos += photos
            self.collectionView?.reloadData()
            self.page += 1
        }
    }
    
    /*
     Set photos asynchronously.
     Check whether the `imageCache` contains the image data, if not, download the image with `photoImageURL` in `Photo` and store it into `imageCache`.
     `photoImageURL` will be downloaded only once unless users restart the app. After downloading, cell's image will always be pulling from cache.
    */
    func setCellImageAsync(cell: GalleryCollectionViewCell, indexPath: IndexPath, completion: @escaping(_ imageData: Data) -> Void) {
        if let cacheNSData = imageCache.object(forKey: self.photos[indexPath.section].id as NSString) {
            completion(cacheNSData as Data)
        } else {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: URL(string: self.photos[indexPath.section].photoImageURL)!)  {
                    DispatchQueue.main.sync {
                        imageCache.setObject(imageData as NSData, forKey: self.photos[indexPath.section].id as NSString)
                        completion(imageData)
                    }
                }
            }
        }
    }
    
    // Preparation work before showing the photo detail.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destination as! PhotoViewController
            if let indexPath = collectionView!.indexPathsForSelectedItems!.first {
                destinationVC.flickrAPIParser = flickrParser
                destinationVC.imageData = imageCache.object(forKey: photos[indexPath.section].id as NSString)! as Data
                destinationVC.photoId = photos[indexPath.section].id
                destinationVC.photoTitle = photos[indexPath.section].photoTitle
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.titleLabel.text = photos[indexPath.section].photoTitle
        setCellImageAsync(cell: cell, indexPath: indexPath) { (imageData) in
            cell.photoImageView.image = UIImage(data: imageData)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // When scroll to the bottom of the collectionView, load more to collectionView if there were still undisplayed data.
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == photos.count - 1 {
            loadInterestingnessList()
        }
    }
}

// Customize the collectionViewCell's size.
extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
}
