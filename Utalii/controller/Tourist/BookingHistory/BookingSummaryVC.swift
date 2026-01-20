//
//  BookingSummaryVC.swift
//  Utalii
//
//  Created by Ladu Ram on 16/05/23.
//

import UIKit

class BookingSummaryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
