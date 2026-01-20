//
//  GuidePaymentHistoryTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit

class GuidePaymentHistoryTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblPaidAmount: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
