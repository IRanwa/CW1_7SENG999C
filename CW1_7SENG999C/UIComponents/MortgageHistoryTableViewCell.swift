//
//  MortgageHistoryTableViewCell.swift
//  CW1_7SENG999C
//
//  Created by user235597 on 7/30/23.
//

import UIKit

class MortgageHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var loanAmtLbl: UILabel!
    @IBOutlet weak var interestLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var noOfYearsLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
