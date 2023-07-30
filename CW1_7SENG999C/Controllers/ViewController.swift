//
//  ViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/28/23.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var compoundLoanSavingImg: UIImageView!
    @IBOutlet weak var mortgageImg: UIImageView!
    @IBOutlet weak var savingsImg: UIImageView!
    @IBOutlet weak var historyImg: UIImageView!
    @IBOutlet weak var helpImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startupImgLoadingAnimation()
    }
    
    func startupImgLoadingAnimation(){
        compoundLoanSavingImg.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.compoundLoanSavingImg.alpha = 1
        })
        
        mortgageImg.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.mortgageImg.alpha = 1
        })
        
        savingsImg.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.savingsImg.alpha = 1
        })
        
        helpImg.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.helpImg.alpha = 1
        })
        
        historyImg.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.historyImg.alpha = 1
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarViewController = segue.destination as? TabBarViewController
        tabBarViewController?.identifier = segue.identifier
        
    }
}

