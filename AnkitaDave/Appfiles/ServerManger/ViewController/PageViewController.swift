//
//  PageViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 10/05/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    
    // MARK: UIPageViewControllerDataSource
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "First"),
                self.newVc(viewController: "Second"),
                self.newVc(viewController: "Third"),
                self.newVc(viewController: "Forth"),
                self.newVc(viewController: "Fith"),
                ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.dataSource = self
        self.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 5))
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 47,width: UIScreen.main.bounds.width,height: 5))
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 52,width: UIScreen.main.bounds.width,height: 5))
                
            case 2436:
                print("iPhone X")
                
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 90,width: UIScreen.main.bounds.width,height: 5))
            default:
                print("unknown")
            }
        }
        
        self.pageControl.numberOfPages =  orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.view.addSubview(pageControl)
    }
    
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func numberOfPages() -> Int {
        return 4 //your number of pages
    }
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        var pageContentViewController = pageViewController.viewControllers![0]
        
        ////        if   {
        ////            pageControl.isHidden = true
        ////        } else {
        ////            pageControl.isHidden = false
        ////        }
        //        if ((pageViewController.viewControllers?.last) != nil) {
        //            pageControl.isHidden = true
        //        } else {
        //            pageControl.isHidden = false
        //        }
        //
        
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //            return orderedViewControllers.last
            
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        
        // User is on the last view controller and swiped right to loop to
        //        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PhotoDiaryCollectionViewController") as! PhotoDiaryCollectionViewController
        //        resultViewController.selectedIndexVal = indexPath.row
        //        self.navigationController?.pushViewController(resultViewController, animated: true)
        
        return orderedViewControllers[nextIndex]
    }
    
}
