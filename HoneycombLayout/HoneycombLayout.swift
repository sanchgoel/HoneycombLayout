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
  
  let elementWidth: CGFloat = 50.0
  
  override func prepare() {
    // Clear out previous results
    cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    // For our implementation we take only one section
    let section = 0
    let numberOfItems = collectionView?.numberOfItems(inSection: section) ?? 0
    
    // We assume the zeroth element to be at center of collection
    guard let center = collectionView?.center else { return }
    
    // One rows is assumed to be comprising of elements contained in concentric hexagons
    // Such as 1st row would have 6 elements, 2nd row 12, 3rd row 18 and so on
    let k = (numberOfItems-1)/6
    let numberOfRows = Int((-1 + sqrt(Double(1+8*k)))/2)
    var prev = 0
  
    for row in 1...numberOfRows {
      var startPoint = CGPoint.zero
      for item in 0..<(6*row) {
        var itemFrame = CGRect.zero
        let rowAngleDeviation = 120.0
        
        if CGFloat(item).truncatingRemainder(dividingBy: CGFloat(row)) == 0 {
          let angleOffsetIndex = Double(Int((item+1)/row))
          let nextAngle = 60.0 * angleOffsetIndex * .pi / 180.0
          let xdelta = 60.0 * CGFloat(row) * CGFloat(cos(nextAngle))
          let ydelta = 60.0 * CGFloat(row) * CGFloat(sin(nextAngle))
          startPoint = CGPoint(x: center.x + xdelta - elementWidth/2.0,
                               y: center.y + ydelta - elementWidth/2.0)
          itemFrame = CGRect(x: startPoint.x,
                             y: startPoint.y,
                             width: 50.0,
                             height: 50.0)
        } else {
          let angleOffsetIndex = Double(Int((item)/row))
          let deviation = (60.0 * angleOffsetIndex + rowAngleDeviation)
          
          let deviationRadians = deviation * .pi / 180.0
          
          let nextPointRadiusDelta = 60.0*CGFloat(item).truncatingRemainder(dividingBy: CGFloat(row))
          
          let nextPoint = CGPoint(x: startPoint.x + nextPointRadiusDelta*CGFloat(cos(deviationRadians)),
                                  y: startPoint.y + nextPointRadiusDelta*CGFloat(sin(deviationRadians)))
          itemFrame = CGRect(x: nextPoint.x,
                             y: nextPoint.y,
                             width: 50.0,
                             height: 50.0)
        }      
                        
        // Create the layout attributes and set the frame
        let indexPath = IndexPath(item: item + prev, section: section)        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = itemFrame

        // Store the results
        cellAttributes[indexPath] = attributes
      }
      prev = prev + 6*row
    }
    
    let indexPath = IndexPath(item: 60, section: section)
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    attributes.frame = CGRect(x: center.x - elementWidth/2.0,
                              y: center.y - elementWidth/2.0,
                              width: 50,
                              height: 50)
      
    cellAttributes[indexPath] = attributes

    computedContentSize = CGSize(width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height)
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
