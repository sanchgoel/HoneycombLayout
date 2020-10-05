//
//  HoneycombLayout.swift
//  HoneycombLayout
//
//  Created by Sanchit Goel on 29/09/20.
//  Copyright © 2020 Sanchit Goel. All rights reserved.
//

import UIKit

class HoneycombLayout: UICollectionViewLayout {
    
  private var computedContentSize: CGSize = CGSize(width: UIScreen.main.bounds.width,
                                                   height: UIScreen.main.bounds.height)
  private var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
  
  var elementWidth: CGFloat = 10.0
  let itemSpacing: CGFloat = 15.0
  var center = CGPoint.zero
  
  override func prepare() {
    super.prepare()
    guard
      cellAttributes.isEmpty,
      let collectionView = collectionView
      else {
        return
    }
    
    // Clear out previous results
    cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
        
    let radius = elementWidth + itemSpacing
    
    // For our implementation we take only one section
    let section = 0
    let numberOfItems = collectionView.numberOfItems(inSection: section)
    
    // We assume the zeroth element to be at center of collection
    center = collectionView.center
    
    // One rows is assumed to be comprising of elements contained in concentric hexagons
    // Such as 1st row would have 6 elements, 2nd row 12, 3rd row 18 and so on
    let k = (numberOfItems-1)/6
    
    // Number of rows is equal to root of equation 6 * [n*(n+1)/2] = number of items
    // n*(n+1)/2 = sum of series 1+2+3+4+5 ...
    // 6n*(n+1)/2 = sum of series 6+12+18+24+30 ...
    
    // Formula for root => (-a + sqrt(b2 - 4ac))/2
    // if total items = 60 then k = 60/6
    let numberOfRows = Int((-1 + sqrt(Double(1+8*k)))/2)
    var prev = 0
    
    // Width of collection's content
    var width = ((elementWidth) * CGFloat(2 * numberOfRows)) + (itemSpacing * CGFloat(2 * numberOfRows))
    
    // Assuming symmetry
    var height = width
    
    // Minimum number of rows that fit in the width of collection
    let thresholdRows = (collectionView.frame.width - elementWidth) / ((elementWidth + itemSpacing) * 2)
    
    // Minimum number of rows that fit in the height of collection
    let thresholdColumns = (collectionView.frame.height - elementWidth) / ((elementWidth + itemSpacing) * 2)
    
    // Shift center along x axis if content width is more than collection width
    if numberOfRows > Int(thresholdRows) {
      let displacementWidthFactor = CGFloat(numberOfRows - Int(thresholdRows) - 1)
      let displacementWidth = (elementWidth + itemSpacing) * displacementWidthFactor
      center = CGPoint(x: center.x + displacementWidth, y: center.y)
    }
    
    // Shift center along y axis if content height is more than collection height
    if numberOfRows > Int(thresholdColumns) {
      let displacementHeightFactor = CGFloat(numberOfRows - Int(thresholdColumns) - 1)
      let displacementHeight = (elementWidth + itemSpacing) * displacementHeightFactor
      center = CGPoint(x: center.x, y: center.y + displacementHeight)
    }
      
    for row in 1...numberOfRows {
      var startPoint = CGPoint.zero
      for item in 0..<(6*row) {
        var itemFrame = CGRect.zero
        let rowAngleDeviation = 120.0
                 
        if CGFloat(item).truncatingRemainder(dividingBy: CGFloat(row)) == 0 {
          let angleOffsetIndex = Double(Int((item+1)/row))
          let nextAngle = 60.0 * angleOffsetIndex * .pi / 180.0
          let xdelta = radius * CGFloat(row) * CGFloat(cos(nextAngle))
          let ydelta = radius * CGFloat(row) * CGFloat(sin(nextAngle))
          startPoint = CGPoint(x: center.x + xdelta - elementWidth/2.0,
                               y: center.y + ydelta - elementWidth/2.0)
          itemFrame = CGRect(x: startPoint.x,
                             y: startPoint.y,
                             width: elementWidth,
                             height: elementWidth)
        } else {
          let angleOffsetIndex = Double(Int((item)/row))
          let deviation = (60.0 * angleOffsetIndex + rowAngleDeviation)
          
          let deviationRadians = deviation * .pi / 180.0
          
          let nextPointRadiusDelta = radius*CGFloat(item).truncatingRemainder(dividingBy: CGFloat(row))
          
          let nextPoint = CGPoint(x: startPoint.x + nextPointRadiusDelta*CGFloat(cos(deviationRadians)),
                                  y: startPoint.y + nextPointRadiusDelta*CGFloat(sin(deviationRadians)))
          itemFrame = CGRect(x: nextPoint.x,
                             y: nextPoint.y,
                             width: elementWidth,
                             height: elementWidth)
        }      
                        
        // Create the layout attributes and set the frame
        let indexPath = IndexPath(item: item + prev, section: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = itemFrame

        // Store the results
        cellAttributes[indexPath] = attributes
      }
      // Keep a count of previous elements that have been added
      prev = prev + 6*row
    }
    
    // Set the frame for the last element which is placed in the center
    let lastIndexPath = IndexPath(item: numberOfItems - 1,
                                  section: section)
    let attributes = UICollectionViewLayoutAttributes(forCellWith: lastIndexPath)
    attributes.frame = CGRect(x: center.x - elementWidth/2.0,
                              y: center.y - elementWidth/2.0,
                              width: elementWidth,
                              height: elementWidth)
      
    cellAttributes[lastIndexPath] = attributes
   
    // Set the width and height of content equal to collection if their size is less than the collection
    if width < collectionView.frame.width {
      width = collectionView.frame.width
    }
    
    if height < collectionView.frame.height {
      height = collectionView.frame.height
    }
    
    // Add insets to the edges of collection
    collectionView.contentInset = UIEdgeInsets(top: 0.0,
                                               left: 2*elementWidth,
                                                bottom: 0,
                                                right: elementWidth)
        
    computedContentSize = CGSize(width: width,
                                 height: height)
    
    // Scroll to first item initially
    collectionView.scrollToItem(at: lastIndexPath,
                                 at: .centeredHorizontally,
                                 animated: false)
  }
  
  override var collectionViewContentSize: CGSize {
    return computedContentSize
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributeList = [UICollectionViewLayoutAttributes]()
    
    for (_, attributes) in cellAttributes {
      if attributes.frame.intersects(rect) {
        attributeList.append(attributes)
      }
    }
    
    return attributeList
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cellAttributes[indexPath]
  }
}
