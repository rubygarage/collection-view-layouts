//
//  InstagramLayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 3/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Fakery
import Nimble
import Quick
@testable import collection_view_layouts

class InstagramStyleLayoutSpec: QuickSpec {
    enum ContentCountType {
        case randomCells
        case twoCells
        case threeCells
    }
    
    private let kInstagramFlowLayoutMaxItems: UInt32 = 40
    private let kInstagramFlowLayoutMinItems: UInt32 = 20
    
    override func spec() {
        let itemsCount = Int(arc4random_uniform(kInstagramFlowLayoutMaxItems) + kInstagramFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check instagram style flow layout") {
            it("should have default values") {
                let instagramStyleFlowLayout = InstagramStyleFlowLayout()
                
                expect(instagramStyleFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(instagramStyleFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                expect(instagramStyleFlowLayout.contentAlign).notTo(equal(DynamicContentAlign.right))
                
                expect(instagramStyleFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(instagramStyleFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(instagramStyleFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(instagramStyleFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(instagramStyleFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(instagramStyleFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(instagramStyleFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                instagramStyleFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(instagramStyleFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(instagramStyleFlowLayout.collectionView).to(beNil())
                expect(instagramStyleFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check instagram style flow layout with default grid mode") {
            it("should have every cell valid frame") {
                let instagramFlowLayout = self.configureInstagramStyleFlowLayout(items: items)
                let attributes = instagramFlowLayout.cachedLayoutAttributes
                
                let cellWidth = UIScreen.main.bounds.width / 3
                
                var rowCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                    expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                    expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * cellWidth))
                    
                    if attr.indexPath.row % 3 == 0 {
                        expect(attr.frame.origin.x).to(equal(0))
                    } else if attr.indexPath.row % 3 == 1 {
                        expect(attr.frame.origin.x).to(beCloseTo(cellWidth))
                    } else if attr.indexPath.row % 3 == 2 {
                        expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2))
                        
                        rowCount += 1
                    }
                }
            }
            
            it("should have every cell valid frame with content padding") {
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                let instagramFlowLayout = self.configureInstagramStyleFlowLayout(contentPadding: contentPadding, items: items)
                let attributes = instagramFlowLayout.cachedLayoutAttributes
                
                let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                
                var rowCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                    expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                    expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * cellWidth + vPadding))
                    
                    if attr.indexPath.row % 3 == 0 {
                        expect(attr.frame.origin.x).to(beCloseTo(hPadding))
                    } else if attr.indexPath.row % 3 == 1 {
                        expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                    } else if attr.indexPath.row % 3 == 2 {
                        expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2 + hPadding))
                        
                        rowCount += 1
                    }
                }
            }
            
            it("should have every cell valid frame with cells padding") {
                let hPadding: CGFloat = 8
                let vPadding: CGFloat = 8
                let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                let instagramFlowLayout = self.configureInstagramStyleFlowLayout(cellsPadding: cellsPadding, items: items)
                let attributes = instagramFlowLayout.cachedLayoutAttributes
                
                let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                
                var rowCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                    expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                    expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * (cellWidth + vPadding)))
                    
                    if attr.indexPath.row % 3 == 0 {
                        expect(attr.frame.origin.x).to(equal(0))
                    } else if attr.indexPath.row % 3 == 1 {
                        expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                    } else if attr.indexPath.row % 3 == 2 {
                        expect(attr.frame.origin.x).to(beCloseTo((cellWidth + hPadding) * 2))
                        
                        rowCount += 1
                    }
                }
            }
            
            describe("Check instagram style flow layout with onre preview cell mode") {
                it("should have every cell valid frame") {
                    let instagramFlowLayout = self.configureInstagramStyleFlowLayout(gridType: .onePreviewCell, items: items)
                    let attributes = instagramFlowLayout.cachedLayoutAttributes
                    
                    let cellWidth = UIScreen.main.bounds.width / 3
                    
                    var rowCount: Int = 0
                    
                    for attr in attributes {
                        if attr.indexPath.row == 0 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(0))
                            expect(attr.frame.origin.x).to(equal(0))
                        } else if attr.indexPath.row == 1 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(cellWidth))
                            expect(attr.frame.origin.x).to(equal(0))
                        } else if attr.indexPath.row == 2 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth * 2))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth * 2))
                            expect(attr.frame.origin.y).to(equal(0))
                            expect(attr.frame.origin.x).to(beCloseTo(cellWidth))
                            
                            rowCount += 2
                        } else {
                            expect(attr.frame.origin.y).to(equal(CGFloat(rowCount) * cellWidth))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(0))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2))
                                
                                rowCount += 1
                            }
                        }
                    }
                }
                
                it("should have two cells valid frame") {
                    let items = ["First", "Second"]
                    let instagramFlowLayout = self.configureInstagramStyleFlowLayout(gridType: .onePreviewCell, items: items)
                    let attributes = instagramFlowLayout.cachedLayoutAttributes
                    
                    let cellWidth = UIScreen.main.bounds.width / 3
                    
                    for attr in attributes {
                        if attr.indexPath.row == 0 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(0))
                            expect(attr.frame.origin.x).to(equal(0))
                        } else if attr.indexPath.row == 1 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(0))
                            expect(attr.frame.origin.x).to(beCloseTo(cellWidth))
                        }
                    }
                }
                
                it("should have every cell valid frame with content padding") {
                    let hPadding: CGFloat = 10
                    let vPadding: CGFloat = 10
                    let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                    let instagramFlowLayout = self.configureInstagramStyleFlowLayout(contentPadding: contentPadding, gridType: .onePreviewCell, items: items)
                    let attributes = instagramFlowLayout.cachedLayoutAttributes
                    
                    let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                    
                    var rowCount: Int = 0
                    
                    for attr in attributes {
                        if attr.indexPath.row == 0 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(vPadding))
                            expect(attr.frame.origin.x).to(equal(hPadding))
                        } else if attr.indexPath.row == 1 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(cellWidth + vPadding))
                            expect(attr.frame.origin.x).to(equal(hPadding))
                        } else if attr.indexPath.row == 2 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth * 2))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth * 2))
                            expect(attr.frame.origin.y).to(equal(vPadding))
                            expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            
                            rowCount += 2
                        } else {
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * cellWidth + vPadding))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(hPadding))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2 + hPadding))
                                
                                rowCount += 1
                            }
                        }
                    }
                }
                
                it("should have every cell valid frame with cells padding") {
                    let hPadding: CGFloat = 8
                    let vPadding: CGFloat = 8
                    let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                    let instagramFlowLayout = self.configureInstagramStyleFlowLayout(cellsPadding: cellsPadding, gridType: .onePreviewCell, items: items)
                    let attributes = instagramFlowLayout.cachedLayoutAttributes
                    
                    let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                    
                    var rowCount: Int = 0
                    
                    for attr in attributes {
                        if attr.indexPath.row == 0 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(0))
                            expect(attr.frame.origin.x).to(equal(0))
                        } else if attr.indexPath.row == 1 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(cellWidth + vPadding))
                            expect(attr.frame.origin.x).to(equal(0))
                        } else if attr.indexPath.row == 2 {
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth * 2 + hPadding))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth * 2 + vPadding))
                            expect(attr.frame.origin.y).to(equal(0))
                            expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            
                            rowCount += 2
                        } else {
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * (cellWidth + vPadding)))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(0))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(equal(cellWidth + hPadding))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(equal(2 * (cellWidth + hPadding)))
                                
                                rowCount += 1
                            }
                        }
                    }
                }
                
                describe("Check instagram style flow layout with regular preview cell mode") {
                    it("should have every cell valid frame") {
                        let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]
                        let instagramFlowLayout = self.configureInstagramStyleFlowLayout(gridType: .regularPreviewCell, items: items)
                        let attributes = instagramFlowLayout.cachedLayoutAttributes
                        
                        let cellWidth = UIScreen.main.bounds.width / 3
                        
                        let firstCellAttributes = attributes[0]
                        let secondCellAttributes = attributes[1]
                        let thirdCellAttributes = attributes[2]
                 
                        var rowCount: Int = 0
                        
                        expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth)))
                        expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth, width: cellWidth, height: cellWidth)))
                        expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: 0, width: cellWidth * 2, height: cellWidth * 2)))
                        
                        rowCount += 2
                        
                        for i in 3...8 {
                            let attr = attributes[i]
                            
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(equal(CGFloat(rowCount) * cellWidth))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(0))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2))
                                
                                rowCount += 1
                            }
                        }
                        
                        let firstLeftCellAttributes = attributes[9]
                        let secondLeftCellAttributes = attributes[10]
                        let thirdLeftCellAttributes = attributes[11]
                        
                        expect(firstLeftCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: CGFloat(rowCount) * cellWidth, width: cellWidth * 2, height: cellWidth * 2)))
                        expect(secondLeftCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: CGFloat(rowCount) * cellWidth, width: cellWidth, height: cellWidth)))
                        expect(thirdLeftCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: CGFloat(rowCount + 1) * cellWidth, width: cellWidth, height: cellWidth)))
                        
                        rowCount += 2
                        
                        for i in 12...17 {
                            let attr = attributes[i]
                            
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * cellWidth))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(0))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2))
                                
                                rowCount += 1
                            }
                        }
                    }
                    
                    
                    it("should have every cell valid frame with content paddings") {
                        let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]
                        let vPadding: CGFloat = 10
                        let hPadding: CGFloat = 10
                        let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                        let instagramFlowLayout = self.configureInstagramStyleFlowLayout(contentPadding: contentPadding, gridType: .regularPreviewCell, items: items)
                        let attributes = instagramFlowLayout.cachedLayoutAttributes
                        
                        let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                        
                        let firstCellAttributes = attributes[0]
                        let secondCellAttributes = attributes[1]
                        let thirdCellAttributes = attributes[2]
                        
                        var rowCount: Int = 0
                        
                        expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: vPadding, width: cellWidth, height: cellWidth)))
                        expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                        expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: vPadding, width: cellWidth * 2, height: cellWidth * 2)))
                        
                        rowCount += 2
                        
                        for i in 3...8 {
                            let attr = attributes[i]
                            
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * cellWidth + vPadding))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(hPadding))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2 + hPadding))
                                
                                rowCount += 1
                            }
                        }
                        
                        let firstLeftCellAttributes = attributes[9]
                        let secondLeftCellAttributes = attributes[10]
                        let thirdLeftCellAttributes = attributes[11]
                        
                        expect(firstLeftCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: CGFloat(rowCount) * cellWidth + vPadding, width: cellWidth * 2, height: cellWidth * 2)))
                        expect(secondLeftCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2 + hPadding, y: CGFloat(rowCount) * cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                        expect(thirdLeftCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2 + hPadding, y: CGFloat(rowCount + 1) * cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                        
                        rowCount += 2
                        
                        for i in 12...17 {
                            let attr = attributes[i]
                            
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * cellWidth + vPadding))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(hPadding))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth * 2 + hPadding))
                                
                                rowCount += 1
                            }
                        }
                    }
                    
                    it("should have every cell valid frame with cells paddings") {
                        let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]
                        let vPadding: CGFloat = 8
                        let hPadding: CGFloat = 8
                        let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                        let instagramFlowLayout = self.configureInstagramStyleFlowLayout(cellsPadding: cellsPadding, gridType: .regularPreviewCell, items: items)
                        let attributes = instagramFlowLayout.cachedLayoutAttributes
                        
                        let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                        
                        let firstCellAttributes = attributes[0]
                        let secondCellAttributes = attributes[1]
                        let thirdCellAttributes = attributes[2]
                        
                        var rowCount: Int = 0
                        
                        expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth)))
                        expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                        expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: 0, width: cellWidth * 2 + vPadding, height: cellWidth * 2 + hPadding)))
                        
                        rowCount += 2
                        
                        for i in 3...8 {
                            let attr = attributes[i]
                            
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * (cellWidth + vPadding)))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(0))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(2 * (cellWidth + hPadding)))
                                
                                rowCount += 1
                            }
                        }
                        
                        let firstLeftCellAttributes = attributes[9]
                        let secondLeftCellAttributes = attributes[10]
                        let thirdLeftCellAttributes = attributes[11]
                        
                        expect(firstLeftCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: CGFloat(rowCount) * (cellWidth + vPadding), width: cellWidth * 2 + hPadding, height: cellWidth * 2 + vPadding)))
                        expect(secondLeftCellAttributes.frame).to(beCloseTo(CGRect(x: 2 * (cellWidth + hPadding), y: CGFloat(rowCount) * (cellWidth + vPadding), width: cellWidth, height: cellWidth)))
                        expect(thirdLeftCellAttributes.frame).to(beCloseTo(CGRect(x: 2 * (cellWidth + hPadding), y: CGFloat(rowCount + 1) * (cellWidth + vPadding), width: cellWidth, height: cellWidth)))
                        
                        rowCount += 2
                        
                        for i in 12...17 {
                            let attr = attributes[i]
                            
                            expect(attr.frame.size.width).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.size.height).to(beLessThanOrEqualTo(cellWidth))
                            expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * (cellWidth + hPadding)))
                            
                            if attr.indexPath.row % 3 == 0 {
                                expect(attr.frame.origin.x).to(equal(0))
                            } else if attr.indexPath.row % 3 == 1 {
                                expect(attr.frame.origin.x).to(beCloseTo(cellWidth + hPadding))
                            } else if attr.indexPath.row % 3 == 2 {
                                expect(attr.frame.origin.x).to(beCloseTo(2 * (cellWidth + hPadding)))
                                
                                rowCount += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func configureInstagramStyleFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), gridType: GridType = .defaultGrid, items: [String]) -> InstagramStyleFlowLayout {
        let flowDelegate = InstagramStyleBaseDelegateMock(items: items)
        let instagramStyleFlowLayout = InstagramStyleFlowLayout()
        instagramStyleFlowLayout.delegate = flowDelegate
        instagramStyleFlowLayout.contentPadding = contentPadding
        instagramStyleFlowLayout.cellsPadding = cellsPadding
        instagramStyleFlowLayout.gridType = gridType
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: instagramStyleFlowLayout)
        collectionView.dataSource = dataSource
        
        instagramStyleFlowLayout.calculateCollectionViewCellsFrames()
        
        return instagramStyleFlowLayout
    }
}
