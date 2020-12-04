```swift
class PresentationControllerWithAutoHeight: UIPresentationController {
    private var dimmingView = UIView()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        self.dimmingView.backgroundColor = UIColor.clear
    }

    /// View position.
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = self.size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerView!.bounds.size
        )

        let containerSize = containerView!.bounds.size
        let widthDiff = containerSize.width - frame.size.width
        let heightDiff = containerSize.height - frame.size.height

        return frame.offsetBy(dx: widthDiff / 2, dy: heightDiff / 2)
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = self.frameOfPresentedViewInContainerView
    }

    /// View size.
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let padding: CGFloat = parentSize.width < 350 ? 10 : 35

        let targetWidth = parentSize.width - (padding * 2)
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        guard let presentedView = self.presentedView else {
            return CGSize(width: parentSize.width - (padding * 2), height: 259)
        }

        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        return CGSize(width: targetWidth, height: targetHeight)
    }

    override func presentationTransitionWillBegin() {
        self.dimmingView.frame = containerView!.frame
        containerView?.addSubview(self.dimmingView)
        self.dimmingView.addSubview(presentedViewController.view)
    }
}
```
