```swift
import AVFoundation

extension AVCaptureVideoPreviewLayer {
    func cropFromOriginalImage(_ original: UIImage) -> UIImage {
        var image = UIImage()

        let previewImageLayerBounds = self.bounds

        let originalWidth = original.size.width
        let originalHeight = original.size.height

        let A = previewImageLayerBounds.origin
        let B = CGPoint(x: previewImageLayerBounds.size.width, y: previewImageLayerBounds.origin.y)
        let D = CGPoint(x: previewImageLayerBounds.size.width, y: previewImageLayerBounds.size.height)

        let a = self.captureDevicePointConverted(fromLayerPoint: A)
        let b = self.captureDevicePointConverted(fromLayerPoint: B)
        let d = self.captureDevicePointConverted(fromLayerPoint: D)

        let posX = floor(b.x * originalHeight)
        let posY = floor(b.y * originalWidth)

        let width: CGFloat = d.x * originalHeight - b.x * originalHeight
        let height: CGFloat = a.y * originalWidth - b.y * originalWidth

        let cropRect = CGRect(x: posX, y: posY, width: width, height: height)

        if let imageRef = original.cgImage?.cropping(to: cropRect) {
            image = UIImage(cgImage: imageRef, scale: 2.5, orientation: .right)
        }

        return image
    }
}
```
