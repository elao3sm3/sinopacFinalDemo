//
//  pageViewVC.swift
//  sinopacFinalDemo
//
//  Created by 品軒 on 2017/3/23.
//  Copyright © 2017年 品軒. All rights reserved.
//

import UIKit

class pageViewVC: UIPageViewController {

    weak var pageDelegate : UIPageViewControllerDelegate?
    
    private(set) lazy var allViewControllers : [UIViewController] = {
        return [self.getViewController(indentifier: "navigationControllerLoveOrNot")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let firstVC = allViewControllers.first{
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        //pageDelegate?.pageViewController(self, didupdatePageCount: allViewControllers.count)
    }
    
    func getViewController(indentifier : String) -> UIViewController{
        return UIStoryboard(name:"main",bundle:nil).instantiateViewController(withIdentifier: "\(indentifier)")
    }
}
extension pageViewVC : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.index(of: viewController) else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            return nil
        }
        
        guard allViewControllers.count > previousIndex else{
            return nil
        }
        return allViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = allViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else{
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else{
            return nil
        }
        return allViewControllers[nextIndex]
    }
}

extension pageViewVC : UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,let index = allViewControllers.index(of: firstViewController){
            //pageDelegate.pageViewController(self, didupdatePageCount: allViewControllers.count)
        }
    }
}
