//
//  OrderPageViewController.swift
//  My1COrders
//
//  Created by Владимир on 11.05.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit
import CoreData

class OrderPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var orderNumber = ""
    var orderDate = ""
    var orderInfo: OrderInfo?
    var currentPageIndex:Int = 0
    
    var loginInfo = LoginInfo()
    var ordersUrl = ""
    var viewControllersArray:[UIViewController] = []
    var pageviewcontroller:UIPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        //
//        self.pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "orderPageID") as! UIPageViewController
//        self.pageviewcontroller.dataSource = self
//        self.pageviewcontroller.delegate = self
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainOrderInfoVC") as! MainOrderInfoViewController
        vc1.orderInfo = orderInfo
        viewControllersArray.append(vc1)
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "additonalOrderInfoVC") as! AddtitionalOrderInfoViewController
        vc2.orderInfo = orderInfo
        viewControllersArray.append(vc2)
        
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "itemsVC") as! ItemsViewController
        vc3.orderInfo = orderInfo
        viewControllersArray.append(vc3)
        
        if let firstViewController = viewControllersArray.first {
             self.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        //
        
        //fetchOrders()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
//        let vc = viewController as? MainOrderInfoViewController
//        let index = (vc?.index ?? 0) - 1
//        return self.pageViewController(for: index)
        guard let viewControllerIndex = viewControllersArray.index(of: viewController as! UIViewController) else {
                   return nil
               }
               let previousIndex = viewControllerIndex - 1
               guard previousIndex >= 0 else {
                   return nil
               }
               guard viewControllersArray.count > previousIndex else {
                   return nil
               }
               return viewControllersArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersArray.index(of: viewController as! UIViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let ViewControllersCount = viewControllersArray.count
        guard ViewControllersCount != nextIndex else {
            return nil
        }
        guard ViewControllersCount > nextIndex else {
            return nil
        }
        return viewControllersArray[nextIndex]
    }

    
    func pageViewController(for index: Int) -> UIViewController? {
//        if index < 0 {
//            return nil
//        } else if index > 3 {
//            return nil
//        }
//        if index == 0 {
//            let vc = storyboard?.instantiateViewController(identifier: "orderPageID") as! MainOrderInfoViewController
//            vc.orderInfo = orderInfo
//        } else if index == 1 {
//
//        } else if index == 2 {
//
//        } else if index == 2 {
//
//        }
        
        return nil
       
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllersArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        if let pageItemController = pendingViewControllers[0] as? UIViewController {
            //currentPageIndex = pageItemController.index
            currentPageIndex = 0
            //pageItemController.printFrame()
        }
    }
    
}
