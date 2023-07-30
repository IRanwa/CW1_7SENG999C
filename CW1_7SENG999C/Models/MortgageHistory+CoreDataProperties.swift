//
//  MortgageHistory+CoreDataProperties.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData


extension MortgageHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MortgageHistory> {
        return NSFetchRequest<MortgageHistory>(entityName: "MortgageHistory")
    }

    @NSManaged public var date: Date?
    @NSManaged public var loanAmt: Double
    @NSManaged public var interest: Double
    @NSManaged public var payment: Double
    @NSManaged public var noOfYears: Int32

}

extension MortgageHistory : Identifiable {

}
