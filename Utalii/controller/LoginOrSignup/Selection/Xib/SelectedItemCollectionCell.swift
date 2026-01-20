//
//  SelectedItemCollectionCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 08/10/22.
//

import UIKit

class SelectedItemCollectionCell: UICollectionViewCell {

    //MARK: Outlet
    @IBOutlet weak var imgCross: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
     
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCross.changePngColorTo(color: white)
    }

}
