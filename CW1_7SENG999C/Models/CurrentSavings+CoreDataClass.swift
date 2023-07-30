//
//  CurrentSavings+CoreDataClass.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(CurrentSavings)
public class CurrentSavings: NSManagedObject {
    convenience init(principalAmt : Double, interest : Double, payment : Double,
                     compoundsPerYear : Int32, paymentsPerYear : Int32, futureValue: Double,
                     numberOfPaymentsTotal: Int32,
                     insertIntoManagedObjectContext context : NSManagedObjectContext) {
        self.init(context: context)
        self.principalAmt = principalAmt
        self.interest = interest
        self.payment = payment
        self.compoundsPerYear = compoundsPerYear
        self.paymentsPerYear = paymentsPerYear
        self.futureValue = futureValue
        self.numberOfPaymentsTotal = numberOfPaymentsTotal
    }
}
