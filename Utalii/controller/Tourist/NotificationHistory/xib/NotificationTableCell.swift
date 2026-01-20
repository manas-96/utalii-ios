//
//  NotificationTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 01/10/22.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
}
