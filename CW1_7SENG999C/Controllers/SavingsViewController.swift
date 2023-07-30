//
//  SavingsViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/28/23.
//

import UIKit
import CoreData

class SavingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var principalAmtTxtField: UITextField!
    @IBOutlet weak var interestTxtField: UITextField!
    @IBOutlet weak var paymentTxtField: UITextField!
    @IBOutlet weak var compoundsPerYearTxtField: UITextField!
    @IBOutlet weak var paymentsPerYearTxtfField: UITextField!
    @IBOutlet weak var futureValueTxtField: UITextField!
    @IBOutlet weak var noOfPaymentsTotalTxtField: UITextField!
    
    var currentSavings : CurrentSavings?
    
    var context:NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.savingsContainer.viewContext;
    }
    
    var validationFields : [String: [String]] = [
        "principalAmt": ["interest", "payment", "compoundsPerYear", "paymentsPerYear", "futureValue"],
        "interest": ["principalAmt", "payment", "compoundsPerYear", "paymentsPerYear", "futureValue"],
        "futureValue": ["principalAmt", "payment", "compoundsPerYear", "paymentsPerYear", "interest"],
        "paymentsPerYear": ["principalAmt", "payment", "compoundsPerYear", "futureValue", "interest"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        principalAmtTxtField.keyboardType = .decimalPad
        interestTxtField.keyboardType = .decimalPad
        paymentTxtField.keyboardType = .decimalPad
        compoundsPerYearTxtField.keyboardType = .numberPad
        paymentsPerYearTxtfField.keyboardType = .numberPad
        futureValueTxtField.keyboardType = .decimalPad
        noOfPaymentsTotalTxtField.keyboardType = .numberPad
        
        principalAmtTxtField.clearButtonMode = .whileEditing
        interestTxtField.clearButtonMode = .whileEditing
        paymentTxtField.clearButtonMode = .whileEditing
        compoundsPerYearTxtField.clearButtonMode = .whileEditing
        paymentsPerYearTxtfField.clearButtonMode = .whileEditing
        futureValueTxtField.clearButtonMode = .whileEditing
        noOfPaymentsTotalTxtField.clearButtonMode = .whileEditing
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        let toolbar = UIToolbar()
        toolbar.items = [doneButton]
        toolbar.sizeToFit()
        
        principalAmtTxtField.inputAccessoryView = toolbar
        interestTxtField.inputAccessoryView = toolbar
        paymentTxtField.inputAccessoryView = toolbar
        compoundsPerYearTxtField.inputAccessoryView = toolbar
        paymentTxtField.inputAccessoryView = toolbar
        futureValueTxtField.inputAccessoryView = toolbar
        noOfPaymentsTotalTxtField.inputAccessoryView = toolbar
        
        principalAmtTxtField.delegate = self
        interestTxtField.delegate = self
        paymentTxtField.delegate = self
        compoundsPerYearTxtField.delegate = self
        paymentsPerYearTxtfField.delegate = self
        futureValueTxtField.delegate = self
        noOfPaymentsTotalTxtField.delegate = self
        
        loadCurrentSavingData()
    }
    
    func loadCurrentSavingData(){
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: "CurrentSavings"
        )
        do{
            let currentSavingsList = try self.context?.fetch(request) as! [CurrentSavings]
            if(currentSavingsList.count > 0){
                currentSavings = currentSavingsList[0]
                
                if let principalAmtValue = currentSavings?.principalAmt{
                    principalAmtTxtField.text = String(format: "%.2f", principalAmtValue)
                }
                if let interestVal = currentSavings?.interest{
                    interestTxtField.text = String(format: "%.2f", interestVal)
                }
                if let paymentValue = currentSavings?.payment{
                    paymentTxtField.text = String(format: "%.2f", paymentValue)
                }
                if let compoundsPerYearValue = currentSavings?.compoundsPerYear{
                    compoundsPerYearTxtField.text = String(compoundsPerYearValue)
                }
                if let paymentsPerYearValue = currentSavings?.paymentsPerYear{
                    paymentsPerYearTxtfField.text = String(paymentsPerYearValue)
                }
                if let futureValue = currentSavings?.futureValue{
                    futureValueTxtField.text = String(format: "%.2f",futureValue)
                }
                if let numberOfPaymentsTotalValue = currentSavings?.numberOfPaymentsTotal{
                    noOfPaymentsTotalTxtField.text = String(numberOfPaymentsTotalValue)
                }
                
                return
            }else{
                currentSavings = CurrentSavings(principalAmt: 0, interest: 0, payment: 0, compoundsPerYear: 0, paymentsPerYear: 0, futureValue: 0, numberOfPaymentsTotal: 0, insertIntoManagedObjectContext: context!)
                try context?.save()
            }
        }catch{
            print("Error in fetching current savings data")
        }
    }
    
    @objc func doneButtonTapped(){
        principalAmtTxtField.resignFirstResponder()
        interestTxtField.resignFirstResponder()
        paymentTxtField.resignFirstResponder()
        compoundsPerYearTxtField.resignFirstResponder()
        paymentTxtField.resignFirstResponder()
        futureValueTxtField.resignFirstResponder()
        noOfPaymentsTotalTxtField.resignFirstResponder()
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
        textField.layer.borderWidth = 0
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
                        resetBGWidth()
                        switch emptyFieldsList[0]{
                        case "principalAmt":
                            calculatePrincipalAmt()
                            status = true
                        case "interest":
                            calculateInterest()
                            status = true
                        case "futureValue":
                            calculateFutureValue()
                            status = true
                        case "paymentsPerYear":
                            calculatePaymentsPerYear()
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
    
    func calculatePrincipalAmt(){
        let a = currentSavings!.paymentsPerYear * currentSavings!.compoundsPerYear
        let b = (1 + ( (currentSavings!.interest/100) / Double(currentSavings!.compoundsPerYear)))
        let principalAmt = currentSavings!.futureValue / pow(b, Double(a))
        currentSavings?.principalAmt = principalAmt
        principalAmtTxtField.text = String(format: "%.2f", currentSavings!.principalAmt)
        principalAmtTxtField.layer.borderWidth = 1
        principalAmtTxtField.layer.borderColor = UIColor.green.cgColor
    }

    func calculateFutureValue(){
        let a = Double(currentSavings!.paymentsPerYear * currentSavings!.compoundsPerYear)
        let b = (currentSavings!.interest/100)/Double(currentSavings!.compoundsPerYear)
        let futureValue = pow(1 + b, a) * currentSavings!.principalAmt
        currentSavings?.futureValue = futureValue
        futureValueTxtField.text = String(format: "%.2f", currentSavings!.futureValue)
        futureValueTxtField.layer.borderWidth = 1
        futureValueTxtField.layer.borderColor = UIColor.green.cgColor
    }

    func calculateInterest(){
        let a = 1 / Double(currentSavings!.paymentsPerYear * currentSavings!.compoundsPerYear)
        let b = (currentSavings!.futureValue / currentSavings!.principalAmt)
        let interestVal = ((pow(b, a) - 1) * Double(currentSavings!.compoundsPerYear)) * 100
        currentSavings?.interest = interestVal
        interestTxtField.text = String(format: "%.2f", currentSavings!.interest)
        interestTxtField.layer.borderWidth = 1
        interestTxtField.layer.borderColor = UIColor.green.cgColor
    }

    func calculatePaymentsPerYear()
    {
        let a =  log(currentSavings!.futureValue / currentSavings!.principalAmt)
        let b =   log(1 + ((currentSavings!.interest/100)/Double(currentSavings!.compoundsPerYear)))
        * Double(currentSavings!.compoundsPerYear)
        let paymentsPerYear = a/b
        currentSavings?.paymentsPerYear = Int32(ceil(paymentsPerYear))
        paymentsPerYearTxtfField.text = String(currentSavings!.paymentsPerYear)
        paymentsPerYearTxtfField.layer.borderWidth = 1
        paymentsPerYearTxtfField.layer.borderColor = UIColor.green.cgColor
    }
    
    @IBAction func resetClick(_ sender: Any) {
        do
        {
            principalAmtTxtField.text = ""
            interestTxtField.text = ""
            paymentTxtField.text = ""
            compoundsPerYearTxtField.text = ""
            paymentsPerYearTxtfField.text = ""
            futureValueTxtField.text = ""
            noOfPaymentsTotalTxtField.text = ""
            
            currentSavings?.principalAmt = 0.0;
            currentSavings?.interest = 0.0;
            currentSavings?.payment = 0.0;
            currentSavings?.compoundsPerYear = 0;
            currentSavings?.paymentsPerYear = 0;
            currentSavings?.futureValue = 0.0;
            currentSavings?.numberOfPaymentsTotal = 0;
            
            try context?.save()
        }catch{
            print("Error in resetting the current saving data")
        }
    }
    
    func resetBGWidth(){
        principalAmtTxtField.layer.borderWidth = 0
        interestTxtField.layer.borderWidth = 0
        paymentTxtField.layer.borderWidth = 0
        compoundsPerYearTxtField.layer.borderWidth = 0
        paymentsPerYearTxtfField.layer.borderWidth = 0
        futureValueTxtField.layer.borderWidth = 0
        noOfPaymentsTotalTxtField.layer.borderWidth = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        storeTextFieldInputData()
    }
    
    func storeTextFieldInputData(){
        do{
            let principalAmtVal = principalAmtTxtField.text
            let interestVal = interestTxtField.text
            let paymentVal = paymentTxtField.text
            let compoundsPerYearVal = compoundsPerYearTxtField.text
            let paymentPerYearVal = paymentsPerYearTxtfField.text
            let futureVal = futureValueTxtField.text
            let noOfPaymentsTotalVal = noOfPaymentsTotalTxtField.text
            
            if let principalAmtStoreVal = Double(principalAmtVal!){
                currentSavings!.principalAmt = principalAmtStoreVal
            }else{
                currentSavings!.principalAmt = 0.0
            }
            if let interestStoreVal = Double(interestVal!){
                currentSavings!.interest = interestStoreVal
            }else{
                currentSavings!.interest = 0.0
            }
            if let paymentStoreVal = Double(paymentVal!){
                currentSavings!.payment = paymentStoreVal
            }else{
                currentSavings!.payment = 0.0
            }
            if let compoundsPerYearStoreVal = Int32(compoundsPerYearVal!){
                currentSavings!.compoundsPerYear = compoundsPerYearStoreVal
            }else{
                currentSavings!.compoundsPerYear = 0
            }
            if let paymentPerYearStoreVal = Int32(paymentPerYearVal!){
                currentSavings!.paymentsPerYear = paymentPerYearStoreVal
            }else{
                currentSavings!.paymentsPerYear = 0
            }
            if let futureStoreVal = Double(futureVal!){
                currentSavings!.futureValue = futureStoreVal
            }else{
                currentSavings!.futureValue = 0.0
            }
            if let noOfPaymentsTotalStoreVal = Int32(noOfPaymentsTotalVal!){
                currentSavings!.numberOfPaymentsTotal = noOfPaymentsTotalStoreVal
            }else{
                currentSavings!.numberOfPaymentsTotal = 0
            }
            try context?.save()
        }catch{
            print("Error in saving current savings data")
        }
    }
    
    func findEmptyFields() -> [String]?{
        var status : Bool = true
        if(currentSavings!.payment <= 0){
            showErrorPopup(message: "Payment field value is invalid.")
            status = false
            paymentTxtField.layer.borderColor = UIColor.red.cgColor
            paymentTxtField.layer.borderWidth = 1
        }
        if(currentSavings!.compoundsPerYear <= 0){
            showErrorPopup(message: "Compounds per year field value is invalid.")
            status = false
            compoundsPerYearTxtField.layer.borderColor = UIColor.red.cgColor
            compoundsPerYearTxtField.layer.borderWidth = 1
        }
        
        if(!status){
            return nil
        }
        var emptyFieldsList : [String] = []
        if(currentSavings?.principalAmt == 0.0){
            emptyFieldsList.append("principalAmt")
        }
        if(currentSavings?.interest == 0.0){
            emptyFieldsList.append("interest")
        }
        if(currentSavings?.paymentsPerYear == 0){
            emptyFieldsList.append("paymentsPerYear")
        }
        if(currentSavings?.futureValue == 0){
            emptyFieldsList.append("futureValue")
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
            _ = SavingsHistory(
                date: Date.now,
                principalAmt: currentSavings!.principalAmt,
                interest: currentSavings!.interest,
                payment: currentSavings!.payment,
                compoundsPerYear: currentSavings!.compoundsPerYear,
                paymentsPerYear: currentSavings!.paymentsPerYear,
                futureValue: currentSavings!.futureValue,
                numberOfPaymentsTotal: currentSavings!.numberOfPaymentsTotal,
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
