//
//  SenderTextTableViewCell.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 13/07/20.
 
//

import UIKit
 
class SenderTextTableViewCell: UITableViewCell {

    //MARK: outlet
    @IBOutlet weak var lbldisc: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblDescTop: NSLayoutConstraint!
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.sizeToFit()

    }
}
