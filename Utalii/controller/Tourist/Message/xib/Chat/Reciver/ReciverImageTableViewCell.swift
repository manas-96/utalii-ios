//
//  ReciverImageTableViewCell.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 14/07/20.
 
//

import UIKit

class ReciverImageTableViewCell: UITableViewCell {

    //MARK: outlet
    @IBOutlet weak var lblReciverName: UILabel!
    @IBOutlet weak var imgReciverImage: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgPdf: UIImageView!
    
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
   //     lbldisc.setRegularFontWithSize(size: TitleFont) 
    }

 
}
