//
//  PopupTransition.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
//
import UIKit

class PopupController: UIPresentationController {
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    @objc func dismiss(){
//        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        let color = UIColor.black.withAlphaComponent(0.5)
        presentedView?.backgroundColor = color
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
//        presentedView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.masksToBounds = true
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

}
class PopupTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let transition = PresentionController()

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PopupController(presentedViewController: presented, presenting: presenting)
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}

class PresentionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        var holdingView: UIView?
        if presenting {
            let toView = transitionContext.view(forKey: .to)!
            containerView.bringSubviewToFront(toView)
            containerView.addSubview(toView)
            toViewController.view.alpha = 0
            if let view = toViewController.view.subviews.first(where: {$0.isKind(of: UIView.self)}) {
                holdingView = view
                view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        }else {
            if let view = fromViewController.view.subviews.first(where: {$0.isKind(of: UIView.self)}) {
                holdingView = view
                view.transform = .identity
            }
        }
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                if self.presenting {
                    toViewController.view.alpha = 1
                    if let view = holdingView {
                        view.transform = .identity
                    }
                }else {
                    if let view = holdingView {
                        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }
                    fromViewController.view.alpha = 0
                }
        }, completion: { finished in
            if !self.presenting {
                fromViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }
}

