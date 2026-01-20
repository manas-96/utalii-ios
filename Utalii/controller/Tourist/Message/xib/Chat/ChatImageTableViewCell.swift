//
//  ChatImageTableViewCell.swift
 
//
//  Created by My Desktop on 21/01/22.
//
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {

    //MARK:- Outlet
    @IBOutlet weak var imgSender: UIImageView!
    @IBOutlet weak var imgReciver: UIImageView!
    
    @IBOutlet weak var imgCheckMark: UIImageView!
    @IBOutlet weak var lblReciverTime: UILabel!
    
    @IBOutlet weak var viewSender: UIView!
    @IBOutlet weak var viewReciver: UIView!
    
    @IBOutlet weak var lblSenderTime: UILabel!
    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    
}
