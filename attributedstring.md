```swift
extension NSAttributedString {
    func withFont(_ font: UIFont) -> NSAttributedString {
        let attributed = NSMutableAttributedString(attributedString: self)
        attributed.addAttribute(.font, value: font, range: NSRange(location: 0, length: self.length))

        return attributed
    }
}
```
