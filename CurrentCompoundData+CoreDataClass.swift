//
//  CurrentCompoundData+CoreDataClass.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/29/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(CurrentCompoundData)
public class CurrentCompoundData: NSManagedObject {
    
    convenience init(presentValue: Double, futureValue : Double, interest : Double, payment : Double, noPaymentsPerYear : Int32,
                     compoundsPerYear : Int32, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        self.init(context: context)
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interest = interest
        self.payment = payment
        self.noPaymentsPerYear = noPaymentsPerYear
        self.compoundsPerYear = compoundsPerYear
    }
}
