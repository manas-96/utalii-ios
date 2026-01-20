//
//  SenderImageTableViewCell.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 14/07/20. 
//

import UIKit

class SenderImageTableViewCell: UITableViewCell {

    //MARK: outlet
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var imgSenderImage: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var imgPdf: UIImageView!
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
   //     lbldisc.setRegularFontWithSize(size: TitleFont) 
    }

 
}
