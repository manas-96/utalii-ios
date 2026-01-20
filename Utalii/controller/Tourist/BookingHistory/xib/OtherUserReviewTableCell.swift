//
//  OtherUserReviewTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 30/11/22.
//

import UIKit
import Cosmos

class OtherUserReviewTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblDate: UILabel!
     
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
}
