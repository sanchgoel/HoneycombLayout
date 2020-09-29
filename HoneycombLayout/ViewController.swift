//
//  ViewController.swift
//  HoneycombLayout
//
//  Created by Sanchit Goel on 29/09/20.
//  Copyright © 2020 Sanchit Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 61
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoneycombCollectionViewCell",
                                                        for: indexPath) as? HoneycombCollectionViewCell  else {
                                                          return UICollectionViewCell()
    }
    return cell
  }
}
