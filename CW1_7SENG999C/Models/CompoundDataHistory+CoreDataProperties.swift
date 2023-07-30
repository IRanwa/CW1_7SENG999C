//
//  CompoundDataHistory+CoreDataProperties.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData
import UIKit


extension CompoundDataHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompoundDataHistory> {
        return NSFetchRequest<CompoundDataHistory>(entityName: "CompoundDataHistory")
    }

    @NSManaged public var presentValue: Double
    @NSManaged public var futureValue: Double
    @NSManaged public var interest: Double
    @NSManaged public var noOfPaymentsPerYear: Int32
    @NSManaged public var compoundsPerYear: Int32
    @NSManaged public var payment: Double
    @NSManaged public var paymentAt: Int32
    @NSManaged public var date: Date?

}

extension CompoundDataHistory : Identifiable {

}
