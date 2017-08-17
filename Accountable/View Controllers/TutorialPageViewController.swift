//
//  TutorialPageViewController.swift
//  Accountable
//
//  Created by Lily Li on 8/3/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let pages = ["TutorialSB0", "TutorialSB1", "TutorialSB2"]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            self.dataSource = self
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialSB0")
            setViewControllers([vc!],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
}
