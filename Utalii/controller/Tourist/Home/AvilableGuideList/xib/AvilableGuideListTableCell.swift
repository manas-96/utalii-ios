//
//  AvilableGuideListTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 23/11/22.
//

import UIKit
import Cosmos

class AvilableGuideListTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgGuide: UIImageView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblAvilableFrom: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var lblIntrests: UILabel!

    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        imgPin.changePngColorTo(color: colorPrimary)
    }
    
}
