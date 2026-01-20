//
//  DefaultPackageModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 22/11/22.
//

import Foundation
import SwiftyJSON

struct DefaultPackageModel{
    var status = ""
    var packages: [Packages]?
    var error = ""
    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        packages = json["packages"].arrayValue.map { Packages($0) }
    }
}

struct Packages {
    
    var packageId = ""
    var packageName = ""
    var duration = ""
    var packageDescription = ""
    var packagePrice = ""
    var packageType = ""
    var currency = ""
    var currencySymbol = ""
    var packageCreatedAt = ""
    var packageStatus = ""
   
    var location = ""
    var latitude = ""
    var longitude = ""
    var placesCovered = ""
    var estimatedTime = ""
    var startTime = ""


    init(_ json: JSON) {
        placesCovered = json["places_covered"].stringValue
        startTime = json["start_time"].stringValue
        estimatedTime = json["estimated_time"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        packageId = json["package_id"].stringValue
        packageName = json["package_name"].stringValue
        duration = json["duration"].stringValue
        packageDescription = json["package_description"].stringValue
        packagePrice = json["package_price"].stringValue
        packageType = json["package_type"].stringValue
        currency = json["currency"].stringValue
        currencySymbol = json["currency_symbol"].stringValue
        packageCreatedAt = json["package_created_at"].stringValue
        packageStatus = json["package_status"].stringValue
    }
    
}
