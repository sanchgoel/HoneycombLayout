# Honeycomb Layout
This project allows you to create a custom honeycomb shaped collection view layout. Sample gif is attached below.

<img src="https://github.com/sanchgoel/HoneycombLayout/blob/master/Video/layout.gif" width="300" />

## How to use
Include the HoneycombLayout file in your project.

Set the class of collection view layout as HoneycombLayout. Then in the viewDidLoad method get the instance of layout and set its element width as shown below.  

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  // Do any additional setup after loading the view.
  let layout = collectionView.collectionViewLayout as? HoneycombLayout
  layout?.elementWidth = 100.0
}
```

Add the collection view delegate methods 
```swift
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
```


For animating cells near the edges add these properties and call the following method in scrollViewDidScroll as shown below. 
```swift
var edgeDistance: CGFloat = 70.0
let minimumScaleFactor: CGFloat = 0.4

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

func scrollViewDidScroll(_ scrollView: UIScrollView) {
  scaleCells()
}
```
