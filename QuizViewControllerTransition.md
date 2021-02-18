```swift
import UIKit

class QuizViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case present
        case dismiss
    }
    
    private let originalFrame: CGRect
    private let transitionType: TransitionType
    private var animatingView = UIView()
    private let vocabLabel: UILabel!
    
    init(originalFrame: CGRect, _ transitionType: TransitionType, vocab: String) {
        self.originalFrame = originalFrame
        self.transitionType = transitionType
        
        animatingView.frame = originalFrame
        animatingView.layer.cornerRadius = Theme.theme.cornerRadius
        animatingView.clipsToBounds = true
        animatingView.backgroundColor = .cell
        
        vocabLabel = UILabel(frame: originalFrame)
        vocabLabel.contentMode = .center
        vocabLabel.textColor = .text
        vocabLabel.textAlignment = .center
        vocabLabel.text = vocab
        vocabLabel.font = .list(size: 25)
        vocabLabel.backgroundColor = .cell
        vocabLabel.layer.cornerRadius = Theme.theme.cornerRadius
        vocabLabel.clipsToBounds = true
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
        containerView.addSubview(animatingView)
        containerView.addSubview(vocabLabel)
        
        let duration = transitionDuration(using: transitionContext)
        
        switch transitionType {
            
        /// Present
        case .present:
            toVC.view.isHidden = true
            containerView.addSubview(toVC.view)
           
            let finalFrame = transitionContext.finalFrame(for: toVC)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }

                self.animatingView.frame = finalFrame
                self.animatingView.backgroundColor = .cell
                
                self.vocabLabel.frame.origin = finalFrame.origin
                self.vocabLabel.frame.size = CGSize(width: finalFrame.size.width, height: 150)
                self.vocabLabel.backgroundColor = .cell
                self.vocabLabel.textColor = .text
                self.vocabLabel.font = .list(size: 70)
                
            }, completion: { didSuccess in
                self.animatingView.removeFromSuperview()
                self.vocabLabel.removeFromSuperview()
                toVC.view.isHidden = false
                
                transitionContext.completeTransition(didSuccess)
            })

        /// Dismiss
        case .dismiss:
            fromVc.view.isHidden = true
            containerView.insertSubview(fromVc.view, at: 0)
            
            let finalFrame = transitionContext.finalFrame(for: fromVc)
            animatingView.frame = finalFrame
            
            vocabLabel.frame.origin = finalFrame.origin
            vocabLabel.frame.size = CGSize(width: finalFrame.size.width, height: 150)
            vocabLabel.backgroundColor = .cell
            vocabLabel.font = .quiz(size: 70)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }

                self.animatingView.frame = self.originalFrame
                self.animatingView.backgroundColor = .cell
                
                self.vocabLabel.frame = self.originalFrame
                self.vocabLabel.backgroundColor = .cell
                self.vocabLabel.font = .list(size: 25)
                
            }, completion: { didSuccess in
                fromVc.view.isHidden = false
                self.animatingView.removeFromSuperview()
                self.vocabLabel.removeFromSuperview()
                
                transitionContext.completeTransition(didSuccess)
            })
        }
    }
}
```
