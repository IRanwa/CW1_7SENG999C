//
//  LoanHelpViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/31/23.
//

import UIKit

class LoanHelpViewController: UIViewController {

    
    @IBOutlet weak var loanTextAreaLbl: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loanTextAreaLbl.text = "In compound loan and savings menu you can find the present value, interest, future value and no of payments per year by filling the details. You have to keep one of the calculation finding field to be empty. If more than one field is empty you will receives a popup message. You entered last information will be stored and provide when comes back to the screen. Once the caculation button clicks those information will be saved in the storage and can be viewed in the history."
        // Do any additional setup after loading the view.
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
