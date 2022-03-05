//
//  Base.swift
//  digger
//
//  Created by amure on 14.04.2021.
//

import UIKit

class BaseVC: UIViewController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}

class BaseNC: UINavigationController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


extension  BaseVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension BaseVC: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from),
              let to = transitionContext.viewController(forKey: .to) else { return }
        
        guard let fromView = from.view,
              let toView = to.view else { return }
        
        let isPresenting = (fromView == view)
        
        let presentingView = isPresenting ? toView : fromView
        
        if isPresenting {
            transitionContext.containerView.addSubview(presentingView)
        }
        
        
        let size = CGSize(width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height)
        
        let offScreenFrame = CGRect(origin: CGPoint(x: 0, y: size.height), size: size)
        
        let onScreenFrame = CGRect(origin: .zero, size: size)
        
        let viewFrame = CGRect(origin: CGPoint(x: 0, y: -size.height), size: size)

        
        presentingView.frame = isPresenting ? offScreenFrame : onScreenFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame = isPresenting ? viewFrame : onScreenFrame
            presentingView.frame = isPresenting ? onScreenFrame : offScreenFrame
            
        } completion: { isSuccess in
            if !isPresenting {
                presentingView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(isSuccess)
        }
    }
}
