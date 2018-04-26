[![Build Status](https://travis-ci.org/rubygarage/collection-view-layouts.svg?branch=master)](https://travis-ci.org/rubygarage/shopapp-shopify-ios)
[![codecov](https://codecov.io/gh/rubygarage/collection-view-layouts/branch/master/graph/badge.svg)](https://codecov.io/gh/rubygarage/collection-view-layouts)

# About

Collection view layouts is a set of custom flow layouts for iOS which imitate general data grid approaches for mobile apps.

# Flow types

<table>
  <tbody>
    <tr>
    	<td align="center">Tags</td>
    	<td align="center">Pinterest</td>
    	<td align="center">500px</td>
    	<td align="center">Instagram</td>
    </tr>
    <tr>
      <td><img src="https://image.ibb.co/dTsGZ7/01_tags.png" width="200"></td>
      <td><img src="https://image.ibb.co/ne0vu7/02_pinterest.png" width="200"></td>
      <td><img src="https://image.ibb.co/iAuc7S/03_px500.png" width="200"></td>
      <td><img src="https://image.ibb.co/dBNau7/04_instagram.png" width="200"></td>
    </tr>
    <tr>
    	<td align="center">Flipboard</td>
    	<td align="center">Facebook</td>
    	<td align="center">Flickr</td>
    </tr>
    <tr>
      <td><img src="https://image.ibb.co/fP4Ygn/05_flipboard.png" width="200"></td>
      <td><img src="https://image.ibb.co/ijVTE7/06_facebook.png" width="200"></td>
      <td><img src="https://image.ibb.co/mqTtgn/07_flickr.png" width="200"></td>
    </tr>
  </tbody>
</table>

## Overview
* 7 popular flow-layouts for iOS collection view
* Tags and Flipboard layouts support left and right content align
* 500px has custom cells layout configuration
* Three modes for instagram layout (default grid mode, one preview cell, regular preview cell)
* Each layout can be configured with content and cells paddings separately
* Tests coverage more than 90%

## Installation

### CocoaPods
MediaWatermark is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following lines (depends on your needs) to your `Podfile`:

```ruby
pod 'collection-view-layouts/Core'
pod 'collection-view-layouts/TagsLayout'
pod 'collection-view-layouts/PinterestLayout'
pod 'collection-view-layouts/Px500Layout'
pod 'collection-view-layouts/InstagramLayout'
pod 'collection-view-layouts/FlipboardLayout'
pod 'collection-view-layouts/FacebookLayout'
pod 'collection-view-layouts/FlickrLayout'
```

## Requirements

iOS: 9.0+  
Swift: 4.1  
CocoaPods: for iOS  

## Example
To run the example project, clone the repo, and run pod install from the Example directory first.

## Usage

Configuration of custom flow layouts is pretty easy:

```swift
var contentFlowLayout: ContentDynamicLayout = TagsStyleFlowLayout()

contentFlowLayout?.delegate = self
contentFlowLayout?.contentPadding = ItemsPadding(horizontal: 10, vertical: 10)
contentFlowLayout?.cellsPadding = ItemsPadding(horizontal: 8, vertical: 8)
contentFlowLayout?.contentAlign = .left

collectionView.collectionViewLayout = contentFlowLayout!
collectionView.reloadData()
```

Also, you have to implement ContentDynamicLayoutDelegate protocol:

```swift
public protocol ContentDynamicLayoutDelegate: class {
    func cellSize(indexPath: IndexPath) -> CGSize
}

func cellSize(indexPath: IndexPath) -> CGSize {
    return cellsSizes[indexPath.row]
}
```


## Author

Sergey Afanasiev

## Getting Help

sergey.afanasiev@rubygarage.org

## License

Collection Flow Layouts is available under the MIT license. See the LICENSE file for more info.