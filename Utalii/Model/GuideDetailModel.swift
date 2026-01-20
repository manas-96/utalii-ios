//
//  GuideDetailModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 24/11/22.
//

import Foundation
import SwiftyJSON

struct GuideDetailModel{
    var status = ""
    var error = ""
    var details: GuideDetails?
    
    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        details = GuideDetails(json["details"])
    }
}
struct GuideDetails {
    
    var userId = ""
    var fullName = ""
    var mobile = ""
    var email = ""
    var descriptions = ""
    var address = ""
    var latitude = ""
    var longitude = ""
    var profilePic = ""
    var coverpic : String?
    var languageKnown = ""
    var placesKnown = ""
    var dob = ""
    var since = ""
    var permanentAddress = ""
    var minimumCharge = ""
    var currencySymbol = ""
    var tourStartTime = ""
    var avgRating = ""
    var totalReviews = ""
    var tripCompleted = ""
    var isAvailability = ""
    var interestList: [String]?
    var videos: [Videos]?
    var license = ""
    var interestListID: [String]?
    var countryNameCode = ""

    init(_ json: JSON) { 
        license = json["license"].stringValue ?? ""
        userId = json["userId"].stringValue 
        fullName = json["fullName"].stringValue
        mobile = json["mobile"].stringValue
        email = json["email"].stringValue
        descriptions = json["descriptions"].stringValue
        address = json["address"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        profilePic = json["profilePic"].stringValue ?? ""
        coverpic = json["coverpic"].stringValue ?? ""
        languageKnown = json["languageKnown"].stringValue
        placesKnown = json["placesKnown"].stringValue
        dob = json["dob"].stringValue
        since = json["since"].stringValue
        permanentAddress = json["permanentAddress"].stringValue
        minimumCharge = json["minimumCharge"].stringValue
        currencySymbol = json["currencySymbol"].stringValue
        tourStartTime = json["tourStartTime"].stringValue
        avgRating = json["avgRating"].stringValue
        totalReviews = json["totalReviews"].stringValue
        tripCompleted = json["tripCompleted"].stringValue
        isAvailability = json["isAvailability"].stringValue
        interestList = json["interestList"].arrayValue.map { $0["title"].stringValue }
        videos = json["videos"].arrayValue.map { Videos($0) }
        interestListID = json["interestList"].arrayValue.map { $0["interestId"].stringValue }
        countryNameCode = json["countryNameCode"].stringValue

    }
    
}
struct Videos {
    var videoId = ""
    var title = ""
    var siteLocation = ""
    var lat = ""
    var lon = ""
    var created = ""
    var updated = ""
    var file = ""
    var coverImg = ""
    
    init(_ json: JSON) {
        videoId = json["videoId"].stringValue
        title = json["title"].stringValue
        siteLocation = json["siteLocation"].stringValue
        lat = json["lat"].stringValue
        lon = json["lon"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
        file = json["file"].stringValue
        coverImg = json["coverImg"].stringValue
    }
    
}
