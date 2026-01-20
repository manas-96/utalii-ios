//
//  TouristMessageTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 30/09/22.
//

import UIKit

class TouristMessageTableCell: UITableViewCell {

    
    //MARK: Outlet
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblServiceID: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnMsg: UIButton!
    
    @IBOutlet weak var btnDetail: UIButton!
    
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var view2Color: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblUnReadCounter: UILabel!
    @IBOutlet weak var viewUnRead: UIView!
    
    
    var isGuide = false
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        lblUnReadCounter.text = "0"
        
        if(isGuide){
            viewColor.backgroundColor = colorAccent
            view2Color.backgroundColor = colorAccent
            viewMain.addViewBorder(borderColor: colorBlue.cgColor, borderWith: 1, borderCornerRadius: 8)
            viewUnRead.backgroundColor = colorAccent
            viewMain.borderWidth = 1
        }
        else{
            viewColor.backgroundColor = colorBlue
            view2Color.backgroundColor = colorBlue
            viewMain.addViewBorder(borderColor: colorAccent.cgColor, borderWith: 1, borderCornerRadius: 8)
            viewUnRead.backgroundColor = colorBlue
            viewMain.borderWidth = 1
        }
        
    }
}
