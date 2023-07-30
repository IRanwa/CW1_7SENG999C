//
//  FAQViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/31/23.
//

import UIKit

class FAQViewController: UIPageViewController{

    var viewControllersList = [UIViewController]()
    var currentPageIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        configureUI()
    }
    
    func configureUI(){
        let storyboard = UIStoryboard(name: "FAQ", bundle: nil)
        
        viewControllersList.append(storyboard.instantiateViewController(withIdentifier:"savingsHelpViewController"))
        viewControllersList.append(storyboard.instantiateViewController(withIdentifier:"mortgageHelpViewController"))
        viewControllersList.append(storyboard.instantiateViewController(withIdentifier:"loanHelpViewController"))
//        viewControllersList.append(storyboard.instantiateViewController(withIdentifier:"historyHelpViewController"))
        
        if let firstViewController = viewControllersList.first {
            setViewControllers([firstViewController],direction: .forward, animated: true, completion: nil)
        }
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.blue
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FAQViewController : UIPageViewControllerDelegate{

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
      return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllersList.count
    }
  
}

// extensions

extension FAQViewController : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllersList.firstIndex(of: viewController), index > 0 else {
            return nil
        }

        return viewControllersList[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        guard let index = viewControllersList.firstIndex(of: viewController), index + 1 < viewControllersList.count else {
            return nil
        }
        
        return viewControllersList[index + 1]
    }
}


