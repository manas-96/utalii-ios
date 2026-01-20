//
//  TouristVideoVCCollectionCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit

class TouristVideoVCCollectionCell: UICollectionViewCell {

    //MARK: Outlet
    @IBOutlet weak var imgAddres: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    @IBOutlet weak var imgBenner: UIImageView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAddres.changePngColorTo(color: colorBlue)
        imgLocation.changePngColorTo(color: colorBlue)
    }

}
