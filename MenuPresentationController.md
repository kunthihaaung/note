```swift
extension MenuViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        MenuViewControllerTransition(.present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        MenuViewControllerTransition(.dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        MenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
```

Presentation Controller

```swift
import UIKit

class MenuPresentationController: UIPresentationController {
    private var dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView.backgroundColor = UIColor.hex(0x000000, alpha: 0.7)
        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
        )
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        let containerSize = containerView!.bounds.size
        frame.size.width = containerSize.width * 0.8
        
        return frame
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
        CGSize(width: parentSize.width * 0.7, height: parentSize.height)
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.frame
        containerView?.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)

        dimmingView.alpha = 0.0

        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.3
        })
    }
    
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.dimmingView.removeFromSuperview()
        })
    }
}
```

Transition

```swift
class MenuViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case present
        case dismiss
    }
    
    private let transitionType: TransitionType
    
    init(_ transitionType: TransitionType) {
        self.transitionType = transitionType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVc = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }

        let containerView = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        
        switch transitionType {
            
        /// Present
        case .present:
            containerView.addSubview(toVC.view)
            let finalFrame = transitionContext.finalFrame(for: toVC)
            toVC.view.frame = toVC.view.frame.offsetBy(dx: -finalFrame.width, dy: 0)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                toVC.view.frame = finalFrame
                
            }, completion: { didSuccess in
                transitionContext.completeTransition(didSuccess)
            })

        /// Dismiss
        case .dismiss:
            containerView.insertSubview(fromVc.view, at: 0)
            let finalFrame = transitionContext.finalFrame(for: fromVc)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                fromVc.view.frame = fromVc.view.frame.offsetBy(dx: -finalFrame.width, dy: 0)
                
            }, completion: { didSuccess in
                transitionContext.completeTransition(didSuccess)
            })
        }
    }
}
```
