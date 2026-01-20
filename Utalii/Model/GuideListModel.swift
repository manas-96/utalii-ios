//
//  GuideListModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 24/11/22.
//

import Foundation
import SwiftyJSON

struct GuideListModel{
    
    var list: [GuideList]?
    var status = ""
    var error = ""
    
    init(_ json: JSON) {
        list = json["list"].arrayValue.map { GuideList($0) }
        status = json["status"].stringValue
        error = json["error"].stringValue
    }
}

struct GuideList{
    var languageKnown = ""
    var minimumCharge = ""
    var mobile = ""
    var dob = ""
    var currencySymbol = ""
    var permanentAddress = ""
    var longitude = ""
    var email = ""
    var descriptions = ""
    var avgRating = ""
    var interestList: [InterestList]?
    var created = ""
    var userId = ""
    var name = ""
    var latitude = ""
    var placesKnown = ""
    var tourStartTime = ""
    var totalReviews = ""
    var address = ""
    var images = ""
    
    init(_ json: JSON) {
        languageKnown = json["languageKnown"].stringValue
        minimumCharge = json["minimumCharge"].stringValue
        mobile = json["mobile"].stringValue
        dob = json["dob"].stringValue
        currencySymbol = json["currencySymbol"].stringValue
        permanentAddress = json["permanentAddress"].stringValue
        longitude = json["longitude"].stringValue
        email = json["email"].stringValue
        descriptions = json["descriptions"].stringValue
        avgRating = json["avgRating"].stringValue
        interestList = json["interestList"].arrayValue.map { InterestList($0) }
        created = json["created"].stringValue
        userId = json["userId"].stringValue
        name = json["name"].stringValue
        latitude = json["latitude"].stringValue
        placesKnown = json["placesKnown"].stringValue
        tourStartTime = json["tourStartTime"].stringValue
        totalReviews = json["totalReviews"].stringValue
        address = json["address"].stringValue
        images = json["images"].stringValue
    }
}
