//
//  mortgageHelpViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/31/23.
//

import UIKit

class MortgageHelpViewController: UIViewController {

    @IBOutlet weak var textAreaLbl: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textAreaLbl.text = "In mortgage menu you can find the loan amount, interest, payment and no of years by filling the details. You have to keep one of the calculation finding field to be empty. If more than one field is empty you will receives a popup message. You entered last information will be stored and provide when comes back to the screen. Once the caculation button clicks those information will be saved in the storage and can be viewed in the history."
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
