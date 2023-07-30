//
//  CurrentCompoundData+CoreDataProperties.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData
import UIKit

extension CurrentCompoundData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentCompoundData> {
        return NSFetchRequest<CurrentCompoundData>(entityName: "CurrentCompoundData")
    }

    @NSManaged public var compoundsPerYear: Int32
    @NSManaged public var futureValue: Double
    @NSManaged public var interest: Double
    @NSManaged public var noPaymentsPerYear: Int32
    @NSManaged public var payment: Double
    @NSManaged public var presentValue: Double
    @NSManaged public var paymentAt: Int32

}

extension CurrentCompoundData : Identifiable {

}
