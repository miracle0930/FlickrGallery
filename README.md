# FlickrGallery
Load yesterday's interestingness from Flickr.

## Animation
<figure>
    <img src = "https://github.com/miracle0930/FlickrGallery/blob/master/screenshots/portrait5s.gif"/>
    <img src = "https://github.com/miracle0930/FlickrGallery/blob/master/screenshots/portrait8P.gif"/>
    <img src = "https://github.com/miracle0930/FlickrGallery/blob/master/screenshots/portraitX.gif"/>
</figure>


## Application Overview
- A two screens application aimming at getting yesterday's interestingness photos with Flickr's RESTful API. 
- Used UICollectionView and custom UICollectionViewCell to hold photos with static image and title.
- Used UIView to design the detail screen. Users can get photo's description, taken date and authors' name.
- Users can use this application under both portrait and landscape mode.


## Directory
Directory | Introduction
---|---
Helpers | Use `Utils` to change data's format. Use `FlickrAPIParser` to build and send request to Flickr.
Views | Use `GalleryCollectionViewCell` to show photos for yesterday's interestingness.
Models | Use `Photo` to contain parameters inorder to build api to get photo's static image and title.
Controllers | Use `GalleryCollectionViewController` to show a list of photos. Use `PhotoViewController` to show photo's detail.

## Features
- Load photos asynchrounsly and use NSCache to store downloaded photo, to optimize the performance of UICollectionView.
- Supported UICollectionView pagination when scroll to the bottom.
- Auto-Layout supported on both portrait and landscape direction.

## Unit Test
FlickrGalleryTests | Intro
---|---
testGeneralPageOnFlickrAPI | Test the correctness of number of photos requested via FlickrAPI during using.
testLoadMoreWhenPageLargerThanTotalPage | Test the correctness of number of photos requested via FlickrAPI when no more data sent back.



