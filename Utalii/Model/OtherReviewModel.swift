//
//  OtherReviewModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 30/11/22.
//

import Foundation
import SwiftyJSON

struct OtherReviewModel{
    var status = ""
        var avg = ""
        var total = ""
        var reviewList: [ReviewList]?
        var error = ""
    
        init(_ json: JSON) {
            error = json["error"].stringValue
            status = json["status"].stringValue
            avg = json["avg"].stringValue
            total = json["total"].stringValue
            reviewList = json["reviewList"].arrayValue.map { ReviewList($0) }
        }
}

struct ReviewList {

    var reviewId = ""
    var userId = ""
    var orderId = ""
    var tripLocation = ""
    var lat = ""
    var lon = ""
    var hireStartDate = ""
    var startTime = ""
    var hireEndDate = ""
    var endTime = ""
    var guideStartTime = ""
    var travellerfullName = ""
    var profilePic = ""
    var rating = ""
    var comments = ""
    var created = ""
    var updated = ""

    init(_ json: JSON) {
        reviewId = json["reviewId"].stringValue
        userId = json["userId"].stringValue
        orderId = json["orderId"].stringValue
        tripLocation = json["tripLocation"].stringValue
        lat = json["lat"].stringValue
        lon = json["lon"].stringValue
        hireStartDate = json["hireStartDate"].stringValue
        startTime = json["startTime"].stringValue
        hireEndDate = json["hireEndDate"].stringValue
        endTime = json["endTime"].stringValue
        guideStartTime = json["guideStartTime"].stringValue
        travellerfullName = json["travellerfullName"].stringValue
        profilePic = json["profilePic"].stringValue
        rating = json["rating"].stringValue
        comments = json["comments"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
    }

}

