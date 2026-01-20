//
//  BookingHistoryTableCell.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit

class BookingHistoryTableCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var imgCal1: UIImageView!
    @IBOutlet weak var imgDate1: UIImageView!
 
    @IBOutlet weak var imgCal2: UIImageView!
    @IBOutlet weak var imgDate2: UIImageView!
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var viewNew: UIView!
    
    @IBOutlet weak var imgBenner: UIImageView!
    
    @IBOutlet weak var lblGuideName: UILabel!
    @IBOutlet weak var lblServiceId: UILabel!
    
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblFromTime: UILabel!
    
    @IBOutlet weak var lblOnDate: UILabel!
    @IBOutlet weak var lblOnTime: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblServiceIdValue: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    //MARK: Variable
    var isGuide = false
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        viewNew.isHidden = true
    }
    
    func setBorder(isGuide: Bool){
        if(isGuide){
            viewMain.addViewBorder(borderColor: colorBlue.cgColor, borderWith: 1, borderCornerRadius: 8)
            imgBenner.addViewBorder(borderColor: colorBlue.cgColor, borderWith: 1, borderCornerRadius: 8)
            imgCal1.changePngColorTo(color: colorBlue)
            imgDate1.changePngColorTo(color: colorBlue)
            imgCal2.changePngColorTo(color: colorBlue)
            imgDate2.changePngColorTo(color: colorBlue)
            imgLocation.changePngColorTo(color: colorBlue)
            
            lblGuideName.textColor = colorAccent
            lblServiceId.textColor = colorAccent
            lblFromDate.textColor = colorAccent
            lblFromTime.textColor = colorAccent
            lblOnDate.textColor = colorAccent
            lblOnTime.textColor = colorAccent
            lblAddress.textColor = colorAccent
            lblServiceIdValue.textColor = colorBlue
        }
        else{
            viewMain.addViewBorder(borderColor: colorAccent.cgColor, borderWith: 1, borderCornerRadius: 8)
            imgBenner.addViewBorder(borderColor: colorAccent.cgColor, borderWith: 1, borderCornerRadius: 8)
            
            imgCal1.changePngColorTo(color: colorAccent)
            imgDate1.changePngColorTo(color: colorAccent)
            imgCal2.changePngColorTo(color: colorAccent)
            imgDate2.changePngColorTo(color: colorAccent)
            imgLocation.changePngColorTo(color: colorAccent)
            
            lblGuideName.textColor = colorBlue
            lblServiceId.textColor = colorBlue
            lblFromDate.textColor = colorBlue
            lblFromTime.textColor = colorBlue
            lblOnDate.textColor = colorBlue
            lblOnTime.textColor = colorBlue
            lblAddress.textColor = colorBlue
            lblServiceIdValue.textColor = colorAccent
        }
        
        
    }
}
