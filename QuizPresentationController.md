```swift
import UIKit

class QuizPresentationController: UIPresentationController {
    private var dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView.backgroundColor = UIColor.hex(0x000000, alpha: 0.7)
//        dimmingView.addGestureRecognizer(
//            UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
//        )
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        let containerSize = containerView!.bounds.size
        let widthDiff = containerSize.width - frame.size.width
        let heightDiff = containerSize.height - frame.size.height
        
        return frame.offsetBy(dx: widthDiff / 2, dy: heightDiff / 2)
    }
    
    /// Tap on dimming view.
    @objc private func dimmingViewTapped(_ sender: Any) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    /// This will affect the final frame of toView in AnimatedTransitioningDelegate
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    /// frameOfPresentedViewInContainerView method will get the size return of this method.
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: parentSize.width * 0.9, height: 400)
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.frame
        containerView?.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)

        dimmingView.alpha = 0.0

        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 0.3
        }, completion: { context in

        })
    }
}
```
