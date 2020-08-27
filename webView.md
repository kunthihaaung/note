Cookies

```swift
class WebViewController: UIViewController {
    private var webView: WKWebView!

    private var preferences: WKPreferences {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        return preferences
    }

    private var config: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.preferences = self.preferences
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        return config
    }

    var url: URL?

    override func loadView() {
        self.webView = WKWebView(frame: .zero, configuration: self.config)
        view = self.webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = self.url {
            let sharedCookies = PreferenceManager.getPashaAuthCookies()

            let dispatchGroup = DispatchGroup()

            if sharedCookies.count > 0 {
                for cookie in sharedCookies {
                    dispatchGroup.enter()
                    self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                    self?.webView.load(URLRequest(url: url))
                }
            }
        }
    }
}
```
