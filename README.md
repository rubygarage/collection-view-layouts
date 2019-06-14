[![Build Status](https://travis-ci.org/rubygarage/collection-view-layouts.svg?branch=master)](https://travis-ci.org/rubygarage/collection-view-layouts)
[![codecov](https://codecov.io/gh/rubygarage/collection-view-layouts/branch/master/graph/badge.svg)](https://codecov.io/gh/rubygarage/collection-view-layouts)

# About

Collection View Layouts is a set of custom layouts for iOS which imitate general data grid approaches for mobile apps.

# Layout types

<table>
  <tbody>
    <tr>
    	<td align="center">Tags</td>
    	<td align="center">Pinterest</td>
    	<td align="center">500px</td>
    	<td align="center">Instagram</td>
    </tr>
    <tr>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/tags.png?raw=true" width="200"></td>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/pinterest.png?raw=true" width="200"></td>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/px500.png?raw=true" width="200"></td>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/instagram.png?raw=true" width="200"></td>
    </tr>
    <tr>
    	<td align="center">Flipboard</td>
    	<td align="center">Facebook</td>
    	<td align="center">Flickr</td>
    </tr>
    <tr>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/flipboard.png?raw=true" width="200"></td>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/facebook.png?raw=true" width="200"></td>
      <td><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/flickr.png?raw=true" width="200"></td>
    </tr>
  </tbody>
</table>

## Overview
* 7 popular layouts for iOS collection view
* Tags and Flipboard layouts support left and right content align
* 500px has custom cells layout configuration
* Three modes for Instagram layout (default grid mode, one preview cell, regular preview cell)
* Each layout can be configured with content and cells paddings separately
* Tests coverage more than 90%

## Installation

### CocoaPods
Collection View Layouts is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following lines (depends on your needs) to your `Podfile`:

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

iOS: 11.0+  
Swift: 5.0  
CocoaPods: for iOS  

## Example
To run the example project, clone the repo, and run pod install from the Example directory first.

## Usage

Configuration of custom layouts is pretty easy:

```swift
var layout: BaseLayout = TagsLayout()

layout.delegate = self
layout.delegate = ItemsPadding(horizontal: 10, vertical: 10)
layout.cellsPadding = ItemsPadding(horizontal: 8, vertical: 8)

collectionView.collectionViewLayout = layout
collectionView.reloadData()
```

Also, you have to implement LayoutDelegate protocol:

```swift
public protocol LayoutDelegate: class {
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

Collection View Layouts is licensed under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0)

***

<a href="https://rubygarage.org/"><img src="https://github.com/rubygarage/collection-view-layouts/blob/master/assets/rubygarage.png?raw=true" alt="RubyGarage Logo" width="415" height="128"></a>

RubyGarage is a leading software development and consulting company in Eastern Europe. Our main expertise includes Ruby and Ruby on Rails, but we successfuly employ other technologies to deliver the best results to our clients. [Check out our portoflio](https://rubygarage.org/portfolio) for even more exciting works!
