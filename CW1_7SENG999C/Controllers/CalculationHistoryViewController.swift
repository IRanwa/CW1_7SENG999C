//
//  CalculationHistoryViewController.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//

import UIKit
import CoreData

class CalculationHistoryViewController: UIViewController, UITableViewDataSource, DataUpdateDelegate {

    var context:NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.compoundLoanAndSavingsContainer.viewContext;
    }
    
    var compoundHistories = [CompoundDataHistory]()
//
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompoundHistory()
        tableView.dataSource = self
    }
    
    func updateData() {
        loadCompoundHistory()
        tableView.reloadData()
    }
    
    func loadCompoundHistory(){
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: "CompoundDataHistory"
        )
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        do{
            compoundHistories = try self.context?.fetch(request) as! [CompoundDataHistory]
        }catch{
            print("Error in fetching compound histories")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return compoundHistories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell and set its content
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "compoundHistoryTableCell", for: indexPath)
        as? CompoundHstoryTableViewCell else{
            fatalError("Compound history table cell dequeue error.")
        }
        // Configure the cell with the appropriate data based on the indexPath
        let dataItem = compoundHistories[indexPath.row]
//        cell.textLabel?.text = dataItem.title
        // Customize the cell further if needed
        print(dataItem.interest)
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

    @IBAction func resetClick(_ sender: Any) {
        do{
            for dataItem in compoundHistories{
                context?.delete(dataItem)
            }
            try context?.save()
        }catch{
            print("Error in resetting the history data")
        }
        loadCompoundHistory()
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
