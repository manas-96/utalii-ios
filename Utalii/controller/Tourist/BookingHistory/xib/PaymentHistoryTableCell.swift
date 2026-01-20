//
//  PaymentHistoryTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit

class PaymentHistoryTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRecipientName: UILabel!
    @IBOutlet weak var lblPaidAmount: UILabel!
    @IBOutlet weak var lblAmountMethod: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
