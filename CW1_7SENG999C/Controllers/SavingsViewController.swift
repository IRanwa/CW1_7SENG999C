//
//  SavingsViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/28/23.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var principalAmtTxtField: UITextField!
    @IBOutlet weak var interestTxtField: UITextField!
    @IBOutlet weak var paymentTxtField: UITextField!
    @IBOutlet weak var compoundsPerYearTxtField: UITextField!
    @IBOutlet weak var paymentsPerYearTxtfField: UITextField!
    @IBOutlet weak var futureValueTxtField: UITextField!
    @IBOutlet weak var noOfPaymentsTotalTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        principalAmtTxtField.keyboardType = .decimalPad
        interestTxtField.keyboardType = .decimalPad
        paymentTxtField.keyboardType = .decimalPad
        compoundsPerYearTxtField.keyboardType = .numberPad
        paymentsPerYearTxtfField.keyboardType = .numberPad
        futureValueTxtField.keyboardType = .decimalPad
        noOfPaymentsTotalTxtField.keyboardType = .numberPad
        
        principalAmtTxtField.delegate = self
        interestTxtField.delegate = self
        paymentTxtField.delegate = self
        compoundsPerYearTxtField.delegate = self
        paymentsPerYearTxtfField.delegate = self
        futureValueTxtField.delegate = self
        noOfPaymentsTotalTxtField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString txtVal: String) -> Bool {
        if textField.keyboardType == .decimalPad {
            if txtVal == "." {
                if textField.text?.contains(".") ?? false {
                    return false
                }
            }else if(txtVal != ""){
                let splitByDecimal = textField.text?.split(separator: ".")
                if let splitByDecimalList = splitByDecimal{
                    if(splitByDecimalList.count > 1 && splitByDecimalList[1].count >= 2){
                        return false
                    }
                }
            }
        }
        return true
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
