//
//  CalculationHistoryViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//

import UIKit
import CoreData

class CalculationHistoryViewController: UIViewController, UITableViewDataSource, DataUpdateDelegate {
    
    var compoundContext:NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.compoundLoanAndSavingsContainer.viewContext;
    }
    
    var mortgageContext:NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.mortgageContainer.viewContext;
    }
    
    var compoundHistories = [CompoundDataHistory]()
    var mortgageHistories = [MortgageHistory]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompoundHistory()
        tableView.dataSource = self
    }
    
    func updateData() {
        if(tabSelector.selectedSegmentIndex == 0){
            loadCompoundHistory()
        }else{
            loadMortgageHistory()
        }
        tableView.reloadData()
    }
    
    func loadCompoundHistory(){
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: "CompoundDataHistory"
        )
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        do{
            compoundHistories = try self.compoundContext?.fetch(request) as! [CompoundDataHistory]
        }catch{
            print("Error in fetching compound histories")
        }
    }
    
    func loadMortgageHistory(){
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: "MortgageHistory"
        )
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        do{
            mortgageHistories = try self.mortgageContext?.fetch(request) as! [MortgageHistory]
        }catch{
            print("Error in fetching mortgage histories")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tabSelector.selectedSegmentIndex == 0){
            return compoundHistories.count
        }else{
            return mortgageHistories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tabSelector.selectedSegmentIndex == 0){
            return compoundDataBind(indexPath: indexPath)
        }else{
            return mortgageDataBind(indexPath: indexPath)
        }
    }
    
    func compoundDataBind(indexPath : IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "compoundHistoryTableCell", for: indexPath)
                as? CompoundHstoryTableViewCell else{
            fatalError("Compound history table cell dequeue error.")
        }
        let dataItem = compoundHistories[indexPath.row]
        cell.dateLbl.text = dataItem.date?.formatted()
        cell.presentValueLbl.text = String(format: "%.2f", dataItem.presentValue)
        cell.futureValueLbl.text = String(format: "%.2f", dataItem.futureValue)
        cell.interestLbl.text = String(format: "%.2f", dataItem.interest)
        cell.noPaymentsPerYearLbl.text = String( dataItem.noOfPaymentsPerYear)
        cell.compoundsPerYearLbl.text = String(dataItem.compoundsPerYear)
        cell.paymentLbl.text = String(format: "%.2f", dataItem.payment)
        
        if(dataItem.paymentAt == 0){
            cell.paymentAtLbl.text = "Start"
        }else{
            cell.paymentAtLbl.text = "End"
        }
        return cell
    }
    
    func mortgageDataBind(indexPath : IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mortgageHistoryTableCell", for: indexPath)
                as? MortgageHistoryTableViewCell else{
            fatalError("Mortgage history table cell dequeue error.")
        }
        let dataItem = mortgageHistories[indexPath.row]
        cell.dateLbl.text = dataItem.date?.formatted()
        cell.loanAmtLbl.text = String(format: "%.2f", dataItem.loanAmt)
        cell.interestLbl.text = String(format: "%.2f", dataItem.interest)
        cell.paymentLbl.text = String(format: "%.2f", dataItem.payment)
        cell.noOfYearsLbl.text = String( dataItem.noOfYears)
        return cell
    }
    
    @IBAction func resetClick(_ sender: Any) {
        if(tabSelector.selectedSegmentIndex == 0){
            do{
                for dataItem in compoundHistories{
                    compoundContext?.delete(dataItem)
                }
                try compoundContext?.save()
            }catch{
                print("Error in resetting the history data")
            }
            loadCompoundHistory()
        }else{
            do{
                for dataItem in mortgageHistories{
                    mortgageContext?.delete(dataItem)
                }
                try mortgageContext?.save()
            }catch{
                print("Error in resetting the mortgage data")
            }
            loadMortgageHistory()
        }
        tableView.reloadData()
    }
    
    
    @IBAction func segmentOnChange(_ sender: Any) {
        if(tabSelector.selectedSegmentIndex == 0){
            loadCompoundHistory()
        }else{
            loadMortgageHistory()
        }
        tableView.reloadData()
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
