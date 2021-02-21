```swift
import Foundation

class JsonCoder<T: Codable> {
    static func decode(fileName: String) -> T? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else  {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}
```
