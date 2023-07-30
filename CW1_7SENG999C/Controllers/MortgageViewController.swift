//
//  MortgageViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/28/23.
//

import UIKit
import CoreData

class MortgageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loanAmtTxtField: UITextField!
    @IBOutlet weak var interestTxtField: UITextField!
    @IBOutlet weak var paymentTxtField: UITextField!
    @IBOutlet weak var noOfYearsTxtField: UITextField!
    
    var currentMortgage : CurrentMortgage?
    
    var context:NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.mortgageContainer.viewContext;
    }
    
    var validationFields : [String: [String]] = [
        "loanAmt": ["interest", "payment", "noOfYears"],
        "interest": ["loanAmt", "payment", "noOfYears"],
        "payment": ["loanAmt", "interest", "noOfYears"],
        "noOfYears": ["loanAmt", "interest", "payment"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loanAmtTxtField.keyboardType = .decimalPad
        interestTxtField.keyboardType = .decimalPad
        paymentTxtField.keyboardType = .decimalPad
        noOfYearsTxtField.keyboardType = .decimalPad
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
                let toolbar = UIToolbar()
                toolbar.items = [doneButton]
                toolbar.sizeToFit()
                
                // Assign the toolbar as the input accessory view of the text field
                loanAmtTxtField.inputAccessoryView = toolbar
                interestTxtField.inputAccessoryView = toolbar
                paymentTxtField.inputAccessoryView = toolbar
                noOfYearsTxtField.inputAccessoryView = toolbar
        
        loanAmtTxtField.delegate = self
        interestTxtField.delegate = self
        paymentTxtField.delegate = self
        noOfYearsTxtField.delegate = self
        
        loadCurrentMortgageData()
    }
    
    func loadCurrentMortgageData(){
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: "CurrentMortgage"
        )
        do{
            let currentMortgageList = try self.context?.fetch(request) as! [CurrentMortgage]
            if(currentMortgageList.count > 0){
                currentMortgage = currentMortgageList[0]
                
                if let loanAmtValue = currentMortgage?.loanAmt{
                    loanAmtTxtField.text = String(format: "%.2f", loanAmtValue)
                }
                if let interestValue = currentMortgage?.interest{
                    interestTxtField.text = String(format: "%.2f", interestValue)
                }
                if let paymentValue = currentMortgage?.payment{
                    paymentTxtField.text = String(format: "%.2f", paymentValue)
                }
                if let noOfYearsValue = currentMortgage?.noOfYears{
                    noOfYearsTxtField.text = String(format: "%.2f", noOfYearsValue)
                }
                
                return
            }else{
                currentMortgage = CurrentMortgage(loanAmt: 0, interest: 0, payment: 0, noOfYear: 0, insertIntoManagedObjectContext: context!)
                try context?.save()
            }
        }catch{
            print("Error in fetching current mortgage data")
        }
    }
    
    @objc func doneButtonTapped(){
        loanAmtTxtField.resignFirstResponder()
        interestTxtField.resignFirstResponder()
        paymentTxtField.resignFirstResponder()
        noOfYearsTxtField.resignFirstResponder()
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

    @IBAction func calculateClick(_ sender: Any) {
        storeTextFieldInputData()
        if let emptyFieldsList = findEmptyFields(){
            if(emptyFieldsList.count > 0){
                var status : Bool = false
                for fieldName in validationFields{
                    let set1 = Set(emptyFieldsList)
                    let set2 = Set(fieldName.value)
                    let elementsOnlyInSecondsList = set2.subtracting(set1)
                    if(emptyFieldsList.contains(fieldName.key) && emptyFieldsList.count <= 2 && !elementsOnlyInSecondsList.isEmpty){
                        switch emptyFieldsList[0]{
                        case "loanAmt":
                            calculateLoanAmt()
                            status = true
                        case "interest":
                            calculateInterest()
                            status = true
                        case "payment":
                            calculatePayment()
                            status = true
                        case "noOfYears":
                            calculateNoOfYears()
                            status = true
                        default:
                            print("Empty option invalid")
                        }
                    }
                }
                if(!status){
                    showErrorPopup(message: "One empty field should be available to do the calculations.")
                }else{
                    storeCalculationHistory()
                }
            }else{
                showErrorPopup(message: "At least one calculation field should be empty.")
            }
        }
    }
    
    func calculateLoanAmt(){
        let monthlyInterest = (currentMortgage!.interest/100)/12
        let a = pow((1 + monthlyInterest),Double(currentMortgage!.noOfYears))
        let loanAmt = (currentMortgage!.payment * monthlyInterest * a) / (a - 1)
        loanAmtTxtField.text = String(format: "%.2f", loanAmt)
        loanAmtTxtField.layer.borderWidth = 1
        loanAmtTxtField.layer.borderColor = UIColor.green.cgColor
    }
    
    func calculatePayment(){
        let monthlyInterest = (currentMortgage!.interest/100)/12
        let a = pow((1 + monthlyInterest),Double(currentMortgage!.noOfYears))
        let payment = currentMortgage!.loanAmt * (monthlyInterest * a / (a - 1))
        paymentTxtField.text = String(format: "%.2f", payment)
        paymentTxtField.layer.borderWidth = 1
        paymentTxtField.layer.borderColor = UIColor.green.cgColor
    }
    
    func calculateNoOfYears(){
        let monthlyInterest = (currentMortgage!.interest/100)/12
        let noOfYears = (log(currentMortgage!.payment) - log(currentMortgage!.payment - currentMortgage!.loanAmt * monthlyInterest)) / log(1 + monthlyInterest)
        noOfYearsTxtField.text = String(format: "%.2f", noOfYears)
        noOfYearsTxtField.layer.borderWidth = 1
        noOfYearsTxtField.layer.borderColor = UIColor.green.cgColor
    }
    
    func calculateInterest(){
        let a = (currentMortgage!.payment / currentMortgage!.loanAmt)
        let interest =  a / (pow((1 + a), (Double(currentMortgage!.noOfYears) - 1)))
        interestTxtField.text = String(format: "%.2f", interest)
        interestTxtField.layer.borderWidth = 1
        interestTxtField.layer.borderColor = UIColor.green.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        storeTextFieldInputData()
    }
    
    func storeTextFieldInputData(){
        do{
            let loanAmtVal = loanAmtTxtField.text
            let interestVal = interestTxtField.text
            let paymentVal = paymentTxtField.text
            let noOfYearsVal = noOfYearsTxtField.text
            
            if let loanAmtStoreVal = Double(loanAmtVal!){
                currentMortgage!.loanAmt = loanAmtStoreVal
            }else{
                currentMortgage!.loanAmt = 0.0
            }
            if let interestStoreVal = Double(interestVal!){
                currentMortgage!.interest = interestStoreVal
            }else{
                currentMortgage!.interest = 0.0
            }
            if let paymentStoreVal = Double(paymentVal!){
                currentMortgage!.payment = paymentStoreVal
            }else{
                currentMortgage!.payment = 0.0
            }
            if let noOfYearsStoreVal = Int32(noOfYearsVal!){
                currentMortgage!.noOfYears = noOfYearsStoreVal
            }else{
                currentMortgage!.noOfYears = 0
            }
            
            try context?.save()
        }catch{
            print("Error in saving current mortgage data")
        }
    }
    
    func findEmptyFields() -> [String]?{
        var emptyFieldsList : [String] = []
        if(currentMortgage?.loanAmt == 0.0){
            emptyFieldsList.append("loanAmt")
        }
        if(currentMortgage?.interest == 0.0){
            emptyFieldsList.append("interest")
        }
        if(currentMortgage?.payment == 0.0){
            emptyFieldsList.append("payment")
        }
        if(currentMortgage?.noOfYears == 0){
            emptyFieldsList.append("noOfYears")
        }
        return emptyFieldsList
    }
    
    func showErrorPopup(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func storeCalculationHistory(){
        do{
            _ = MortgageHistory(
                date: Date.now,
                loanAmt: currentMortgage!.loanAmt,
                interest: currentMortgage!.interest,
                payment: currentMortgage!.payment,
                noOfYear: currentMortgage!.noOfYears,
                insertIntoManagedObjectContext: context!)
            try context?.save()
        }catch{
            print("Error in saving calculation history")
        }
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
