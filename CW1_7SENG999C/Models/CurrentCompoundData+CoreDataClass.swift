//
//  CurrentCompoundData+CoreDataClass.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(CurrentCompoundData)
public class CurrentCompoundData: NSManagedObject {

    convenience init(presentValue : Double, futureValue : Double, interest : Double,
                     noOfPaymentsPerYear : Int32, compoundsPerYear : Int32, payment : Double, paymentAt: Int32,
                     insertIntoManagedObjectContext context : NSManagedObjectContext) {
        self.init(context: context)
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interest = interest
        self.noPaymentsPerYear = noOfPaymentsPerYear
        self.compoundsPerYear = compoundsPerYear
        self.payment = payment
        self.paymentAt = paymentAt
    }
}
