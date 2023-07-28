//
//  TabBarViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/28/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    var identifier : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let identifierVal = identifier {
            print(identifierVal)
            switch identifierVal {
                case "Loans":
                    self.selectedIndex = 0
                case "Mortgage":
                    self.selectedIndex = 1
                case "Savings":
                    self.selectedIndex = 2
                default:
                    return
            }
        }else{
            return
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("\(item)")
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
