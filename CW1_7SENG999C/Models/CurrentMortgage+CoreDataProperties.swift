//
//  CurrentMortgage+CoreDataProperties.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//
//

import Foundation
import CoreData


extension CurrentMortgage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentMortgage> {
        return NSFetchRequest<CurrentMortgage>(entityName: "CurrentMortgage")
    }

    @NSManaged public var loanAmt: Double
    @NSManaged public var interest: Double
    @NSManaged public var payment: Double
    @NSManaged public var noOfYears: Int32

}

extension CurrentMortgage : Identifiable {

}
