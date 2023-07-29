//
//  LoanViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/29/23.
//

import UIKit
import CoreData

class LoanViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var presentTxtField: UITextField!
    @IBOutlet weak var futureTxtField: UITextField!
    @IBOutlet weak var interestTxtField: UITextField!
    @IBOutlet weak var paymentTxtField: UITextField!
    @IBOutlet weak var noPaymentPerYearTxtField: UITextField!
    @IBOutlet weak var compoundPerYearTxtField: UITextField!
    
    var currentCompoundData : CurrentCompoundData?
    
    var context:NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.compoundLoanAndSavingsContainer.viewContext;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Keyboard numbering
        presentTxtField.keyboardType = .decimalPad
        futureTxtField.keyboardType = .decimalPad
        interestTxtField.keyboardType = .decimalPad
        paymentTxtField.keyboardType = .decimalPad
        noPaymentPerYearTxtField.keyboardType = .numberPad
        compoundPerYearTxtField.keyboardType = .numberPad
        
        presentTxtField.clearButtonMode = .whileEditing
        futureTxtField.clearButtonMode = .whileEditing
        interestTxtField.clearButtonMode = .whileEditing
        paymentTxtField.clearButtonMode = .whileEditing
        noPaymentPerYearTxtField.clearButtonMode = .whileEditing
        compoundPerYearTxtField.clearButtonMode = .whileEditing
        
        presentTxtField.delegate = self
        futureTxtField.delegate = self
        interestTxtField.delegate = self
        paymentTxtField.delegate = self
        noPaymentPerYearTxtField.delegate = self
        compoundPerYearTxtField.delegate = self
        
        loadCurrentCompoundData()
    }
    
    func loadCurrentCompoundData(){
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: "CurrentCompoundData"
        )
        do{
            let currentCompoundDataList = try self.context?.fetch(request) as! [CurrentCompoundData]
            if(currentCompoundDataList.count > 0){
                currentCompoundData = currentCompoundDataList[0]
                
                if let presentValue = currentCompoundData?.presentValue{
                    presentTxtField.text = String(format: "%.2f", presentValue)
                }
                if let futureValue = currentCompoundData?.futureValue{
                    futureTxtField.text = String(format: "%.2f", futureValue)
                }
                if let interest = currentCompoundData?.interest{
                    interestTxtField.text = String(format: "%.2f", interest)
                }
                if let paymentValue = currentCompoundData?.payment{
                    paymentTxtField.text = String(format: "%.2f", paymentValue)
                }
                if let noPaymentsPerYear = currentCompoundData?.noPaymentsPerYear{
                    noPaymentPerYearTxtField.text = String(noPaymentsPerYear)
                }
                if let compoundsPerYear = currentCompoundData?.compoundsPerYear{
                    compoundPerYearTxtField.text = String(compoundsPerYear)
                }
                
                return
            }else{
                currentCompoundData = CurrentCompoundData(presentValue: 0.0, futureValue: 0.0, interest: 0.0, payment: 0.0, noPaymentsPerYear: 0, compoundsPerYear: 0, insertIntoManagedObjectContext: context!)
                try context?.save()
            }
        }catch{
            print("Error in fetching current compound data")
        }
    }
    
    @IBAction func calculateClick(_ sender: Any) {
        if let emptyFieldsList = findEmptyFields(){
            if(emptyFieldsList.count > 0){
                if(emptyFieldsList.count == 1){
                    switch emptyFieldsList[0]{
                        case "presentValue":
                            calculatePresentValue()
                    case "futureValue":
                            print("futureValue")
                    case "interest":
                            print("interest")
                    case "payment":
                            print("payment")
                    default:
                        print("Empty option invalid")
                    }
                }else{
                    showErrorPopup(message: "One empty field should be available to do the calculations.")
                }
            }else{
                showErrorPopup(message: "At least one calculation field should be empty.")
            }
        }
    }
    
    func calculatePresentValue(){
        print(currentCompoundData!.noPaymentsPerYear)
        print(currentCompoundData!.compoundsPerYear)
        print(currentCompoundData!.interest)
        print(currentCompoundData!.futureValue)
        let a = currentCompoundData!.noPaymentsPerYear * currentCompoundData!.compoundsPerYear
        let b = (1 + ( (currentCompoundData!.interest/100) / Double(currentCompoundData!.compoundsPerYear)))
        let presentVal = currentCompoundData!.futureValue / pow(b, Double(a))
        print(presentVal)
        presentTxtField.text = String(format: "%.2f", presentVal)
        presentTxtField.layer.borderWidth = 1
        presentTxtField.layer.borderColor = UIColor.green.cgColor
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
        textFieldChangeUpdate()
        return true
    }
    
    @IBAction func resetClick(_ sender: Any) {
        do
        {
            presentTxtField.text = ""
            futureTxtField.text = ""
            interestTxtField.text = ""
            paymentTxtField.text = ""
            noPaymentPerYearTxtField.text = ""
            compoundPerYearTxtField.text = ""
            
            currentCompoundData?.presentValue = 0.0;
            currentCompoundData?.futureValue = 0.0;
            currentCompoundData?.interest = 0.0;
            currentCompoundData?.payment = 0.0;
            currentCompoundData?.noPaymentsPerYear = 0;
            currentCompoundData?.compoundsPerYear = 0;
            
            try context?.save()
        }catch{
            print("Error in resetting the current compound data")
        }
    }
    
    //func textFieldDidEndEditing(_ textField: UITextField) {
    func textFieldChangeUpdate() {
        do{
            let presentVal = presentTxtField.text
            let futureVal = futureTxtField.text
            let interestVal = interestTxtField.text
            let paymentVal = paymentTxtField.text
            let noPaymentPerYearVal = noPaymentPerYearTxtField.text
            let compoundPerYearVal = compoundPerYearTxtField.text
            
            if let presentStoreVal = Double(presentVal!){
                currentCompoundData!.presentValue = presentStoreVal
            }else{
                currentCompoundData!.presentValue = 0.0
            }
            if let futureStoreVal = Double(futureVal!){
                currentCompoundData!.futureValue = futureStoreVal
            }else{
                currentCompoundData!.futureValue = 0.0
            }
            if let interestStoreVal = Double(interestVal!){
                currentCompoundData!.interest = interestStoreVal
            }else{
                currentCompoundData!.interest = 0.0
            }
            if let paymentStoreVal = Double(paymentVal!){
                currentCompoundData!.payment = paymentStoreVal
            }else{
                currentCompoundData!.payment = 0.0
            }
            if let noPaymentPerYearStoreVal = Int32(noPaymentPerYearVal!){
                currentCompoundData!.noPaymentsPerYear = noPaymentPerYearStoreVal
            }else{
                currentCompoundData!.noPaymentsPerYear = 0
            }
            if let compoundPerYearStoreVal = Int32(compoundPerYearVal!){
                currentCompoundData!.compoundsPerYear = compoundPerYearStoreVal
            }else{
                currentCompoundData!.compoundsPerYear = 0
            }
            
            try context?.save()
        }catch{
            print("Error in saving current compound data")
        }
    }
    
    func findEmptyFields() -> [String]?{
        var status : Bool = true
        if(currentCompoundData!.noPaymentsPerYear <= 0){
            showErrorPopup(message: "No of payment per year field value is invalid.")
            status = false
            noPaymentPerYearTxtField.layer.borderColor = UIColor.red.cgColor
            noPaymentPerYearTxtField.layer.borderWidth = 1
        }
        if(currentCompoundData!.compoundsPerYear <= 0){
            showErrorPopup(message: "Compounds per year field value is invalid.")
            status = false
            compoundPerYearTxtField.layer.borderColor = UIColor.red.cgColor
            compoundPerYearTxtField.layer.borderWidth = 1
        }
        
        if(!status){
            return nil
        }
        
        var emptyFieldsList : [String] = []
        if(currentCompoundData?.presentValue == 0.0){
                emptyFieldsList.append("presentValue")
            }
        if(currentCompoundData?.futureValue == 0.0){
            emptyFieldsList.append("futureValue")
        }
        if(currentCompoundData?.interest == 0.0){
            emptyFieldsList.append("interest")
        }
        if(currentCompoundData?.payment == 0.0){
            emptyFieldsList.append("payment")
        }
        return emptyFieldsList
    }
    
    func showErrorPopup(message: String) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
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
