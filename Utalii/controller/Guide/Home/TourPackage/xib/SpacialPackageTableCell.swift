//
//  SpacialPackageTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 22/11/22.
//

import UIKit

class SpacialPackageTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCurrncy: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDayMonth: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblPlaceOfCover: UILabel!
    @IBOutlet weak var lblEstimatedTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
  
    @IBOutlet weak var lblEdit: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgDelete: UIImageView!
    
    @IBOutlet weak var viewMain: UIView!
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        lblEdit.changePngColorTo(color: white)
    }
}
