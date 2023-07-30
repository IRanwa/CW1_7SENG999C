//
//  CurrentSavings+CoreDataProperties.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData
import UIKit

extension CurrentSavings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentSavings> {
        return NSFetchRequest<CurrentSavings>(entityName: "CurrentSavings")
    }

    @NSManaged public var principalAmt: Double
    @NSManaged public var interest: Double
    @NSManaged public var payment: Double
    @NSManaged public var compoundsPerYear: Int32
    @NSManaged public var paymentsPerYear: Int32
    @NSManaged public var futureValue: Double
    @NSManaged public var numberOfPaymentsTotal: Int32

}

extension CurrentSavings : Identifiable {

}
