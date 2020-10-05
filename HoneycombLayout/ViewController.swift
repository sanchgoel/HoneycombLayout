//
//  ViewController.swift
//  HoneycombLayout
//
//  Created by Sanchit Goel on 29/09/20.
//  Copyright © 2020 Sanchit Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  
  var edgeDistance: CGFloat = 70.0
  let minimumScaleFactor: CGFloat = 0.4
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let layout = collectionView.collectionViewLayout as? HoneycombLayout
    layout?.elementWidth = 100.0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scaleCells()
  }
  
  func scaleCells() {
    for cell in collectionView.visibleCells {
      let center = collectionView.convert(cell.center, to: self.view)

      if center.x < 0 || center.x > collectionView.frame.width
      || center.y < 0 || center.y > collectionView.frame.height {
        cell.transform = CGAffineTransform(scaleX: minimumScaleFactor,
                                           y: minimumScaleFactor)
        continue
      }

      if center.x >= edgeDistance && center.x <= collectionView.frame.width - edgeDistance
      && center.y <= collectionView.frame.height - edgeDistance && center.y >= edgeDistance {
        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        continue
      }

      if center.x < edgeDistance {
        let factor = 1 - (edgeDistance - center.x)/edgeDistance
        let factorToSet = factor > minimumScaleFactor ? factor : minimumScaleFactor
        cell.transform = CGAffineTransform(scaleX: factorToSet,
                                           y: factorToSet)
        continue
      }

      if center.y < edgeDistance {
        let factor = 1 - (edgeDistance - center.y)/edgeDistance
        let factorToSet = factor > minimumScaleFactor ? factor : minimumScaleFactor
        cell.transform = CGAffineTransform(scaleX: factorToSet,
                                           y: factorToSet)
        continue
      }

      if center.x > collectionView.frame.width - edgeDistance {
        let factor = abs(center.x - collectionView.frame.width)/edgeDistance
        let factorToSet = factor > minimumScaleFactor ? factor : minimumScaleFactor
        cell.transform = CGAffineTransform(scaleX: factorToSet,
                                           y: factorToSet)
        continue
      }

      if center.y > collectionView.frame.height - edgeDistance {
        let factor = abs(center.y - collectionView.frame.height)/edgeDistance
        let factorToSet = factor > minimumScaleFactor ? factor : minimumScaleFactor
        cell.transform = CGAffineTransform(scaleX: factorToSet,
                                           y: factorToSet)
        continue
      }
    }
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 169
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoneycombCollectionViewCell",
                                                        for: indexPath) as? HoneycombCollectionViewCell  else {
                                                          return UICollectionViewCell()
    }
    return cell
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scaleCells()
  }
}
