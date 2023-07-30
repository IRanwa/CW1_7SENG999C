//
//  CompoundHstoryTableViewCell.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//

import UIKit

class CompoundHstoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var presentValueLbl: UILabel!
    @IBOutlet weak var futureValueLbl: UILabel!
    @IBOutlet weak var interestLbl: UILabel!
    @IBOutlet weak var noPaymentsPerYearLbl: UILabel!
    @IBOutlet weak var compoundsPerYearLbl: UILabel!
    @IBOutlet weak var paymentAtLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
