//
//  MortgageHistory+CoreDataClass.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData

@objc(MortgageHistory)
public class MortgageHistory: NSManagedObject {
    convenience init(date : Date, loanAmt : Double, interest : Double, payment : Double,
                     noOfYear : Int32, insertIntoManagedObjectContext context : NSManagedObjectContext) {
        self.init(context: context)
        self.loanAmt = loanAmt
        self.interest = interest
        self.payment = payment
        self.noOfYears = noOfYear
        self.date = date
    }
}
