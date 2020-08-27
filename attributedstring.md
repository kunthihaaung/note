Font

```swift
extension NSAttributedString {
    func withFont(_ font: UIFont) -> NSAttributedString {
        let attributed = NSMutableAttributedString(attributedString: self)
        attributed.addAttribute(.font, value: font, range: NSRange(location: 0, length: self.length))

        return attributed
    }
}
```

Link

```swift
extension String {
    func makeAttributedTextForLink(_ link: String? = nil, value: String? = nil, font: UIFont, lineSpacing: CGFloat) -> NSAttributedString {
        let attribute = NSMutableAttributedString.init(string: self)
        var range: NSRange?

        if let link = link {
            range = (self as NSString).range(of: link)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        attribute.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attribute.length))
        attribute.addAttribute(.font, value: font, range: NSRange(location: 0, length: attribute.length))

        if let value = value, let range = range {
            attribute.addAttribute(.link, value: value, range: range)
        }

        return attribute
    }
}
```
