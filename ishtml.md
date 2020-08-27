# isHTML

```swift
extension String {
    var isHtml: Bool {
        let regex = try? NSRegularExpression(pattern: "<[^>]+>")
        if let results = regex?.matches(in: self, range: NSRange(self.startIndex..., in: self)) {
            return results.count > 0
        } else {
            return false
        }
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
```
