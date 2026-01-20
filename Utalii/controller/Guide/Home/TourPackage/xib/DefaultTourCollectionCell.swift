//
//  DefaultTourCollectionCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 22/11/22.
//

import UIKit

class DefaultTourCollectionCell: UICollectionViewCell {

    //MARK: Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDayorMonth: UILabel!
    @IBOutlet weak var lblDEsc: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
