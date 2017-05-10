//
//  rMAnimation.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/5/8.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class rMAnimation: NSObject, UIViewControllerAnimatedTransitioning{

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
//        let fromVC = transitionContext.viewController(forKey: .from)
//        let fromView = fromVC?.view
//        
//        let toVC = transitionContext.viewController(forKey: .to)
//        let toView = toVC?.view
//        
//        let finalView = transitionContext.finalFrame(for: toView)
//
//        let containerView = transitionContext.containerView
//        
//        let bounds = UIScreen.main.bounds
//        
//        toView?.frame = CGRectOffset()
//        
//        UIView.animate(withDuration: 1, animations: {
//            
//            
//            
//        }){ finished in
//            transitionContext.completeTransition(true)
//        }
//        
    }
}
