ViewController From Storyboard

```swift
import UIKit

extension UIViewController {
    static func fromStoryBoard<T: UIViewController>(_ name: String) -> T? {
        UIStoryboard(name: name, bundle: nil).instantiateViewController(identifier: String(describing: T.self)) as? T
    }
}
```

View from Nib

```swift
extension UIView {
    static func fromNib<T>() -> T? {
        let name = String(describing: T.self)
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else {
            return nil
        }
        return nib.first as? T
    }
}
```
