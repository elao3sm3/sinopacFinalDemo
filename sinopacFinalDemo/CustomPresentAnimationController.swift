//
//  CustomPresentAnimationController.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/4/16.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning{

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let fromView = fromVC?.view
        let toView = toVC?.view
        
//        let bound = UIScreen.main.bounds
//        toView?.frame = CGRect(x: 0, y: , width: <#T##Int#>, height: <#T##Int#>)
//        
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        toView?.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            fromView?.alpha = 0
        }, completion: {
            finished in
            UIView.animate(withDuration: 0.4, animations: {
                toView?.alpha = 1
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
            })
        })
        
        /*
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds 
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
            fromViewController.view.alpha = 1.0
        })*/
    }
}
    
