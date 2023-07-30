//
//  SavingsHistory+CoreDataProperties.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData


extension SavingsHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingsHistory> {
        return NSFetchRequest<SavingsHistory>(entityName: "SavingsHistory")
    }

    @NSManaged public var principalAmt: Double
    @NSManaged public var interest: Double
    @NSManaged public var payment: Double
    @NSManaged public var compoundsPerYear: Int32
    @NSManaged public var paymentsPerYear: Int32
    @NSManaged public var futureValue: Double
    @NSManaged public var numberOfPaymentsTotal: Int32
    @NSManaged public var date: Date?

}

extension SavingsHistory : Identifiable {

}
