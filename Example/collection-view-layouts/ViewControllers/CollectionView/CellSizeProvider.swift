//
//  CellSizesProvider.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

class CellSizeProvider {
    private static let kTagsPadding: CGFloat = 15
    private static let kMinCellSize: UInt32 = 50
    private static let kMaxCellSize: UInt32 = 100
    
    class func provideSizes(items: [String], flowType: FlowLayoutType) -> [CGSize] {
        var cellSizes = [CGSize]()
        var size: CGSize = .zero
        
        for item in items {
            if flowType == .tags {
                size =  CellSizeProvider.provideTagCellSize(item: item)
            } else if flowType == .pinterest {
                size = CellSizeProvider.providePinterestCellSize(item: item)
            } else if flowType == .px500 {
                size = CellSizeProvider.provide500PxCellSize(item: item)
            } else if flowType == .instagram {
                size = CellSizeProvider.provideInstagramCellSize(item: item)
            } else if flowType == .flipboard {
                size = CellSizeProvider.provideFlipboardCellSize(item: item)
            } else if flowType == .facebook {
                size = CellSizeProvider.provideFacebookCellSize(item: item)
            } else if flowType == .flickr {
                size = CellSizeProvider.provideFlickrCellSize(item: item)
            }
            
            cellSizes.append(size)
        }
       
        return cellSizes
    }
    
    private class func provideTagCellSize(item: String) -> CGSize {
        var size = UIFont.systemFont(ofSize: 17).sizeOfString(string: item, constrainedToWidth: Double(UIScreen.main.bounds.width))
        size.width += kTagsPadding
        size.height += kTagsPadding
        
        return size
    }
    
    private class func providePinterestCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provide500PxCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provideInstagramCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provideFlipboardCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provideFacebookCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provideFlickrCellSize(item: String) -> CGSize {
        return CellSizeProvider.provideRandomCellSize(item: item)
    }
    
    private class func provideRandomCellSize(item: String) -> CGSize {
        let width = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        let height = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        
        return CGSize(width: width, height: height)
    }
}
