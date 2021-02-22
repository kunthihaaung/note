```swift
let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
layout.itemSize = CGSize(width: collectionView.bounds.width / 3.3, height: collectionView.bounds.width / 3.3)
layout.minimumInteritemSpacing = 0
layout.minimumLineSpacing = 0
collectionView.collectionViewLayout = layout
```
