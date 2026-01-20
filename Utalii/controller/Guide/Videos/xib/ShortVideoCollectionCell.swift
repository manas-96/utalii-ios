//
//  ShortVideoCollectionCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit

class ShortVideoCollectionCell: UICollectionViewCell {
    //MARK: Outlet
    @IBOutlet weak var imgBenner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgDelete: UIImageView!
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
