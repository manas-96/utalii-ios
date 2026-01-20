//
//  GuideDashboardModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 20/11/22.
//

import Foundation
import SwiftyJSON

struct GuideDashboardModel{
    var status = ""
    var detail: Detail?
    var error = ""

    init(_ json: JSON) {
        status = json["status"].stringValue
        detail = Detail(json["detail"])
        error = json["error"].stringValue
    }
}

struct Detail {
    var userId = ""
    var fullName = ""
    var userType = ""
    var email = ""
    var mobile = ""
    var descriptions = ""
    var address = ""
    var latitude = ""
    var longitude = ""
    var permanentAddress = ""
    var country = ""
    var state = ""
    var city = ""
    var pincode = ""
    var newRequest = 0
    var totalUnreadMsgCount = 0
    var inProgress: InProgress?

    init(_ json: JSON) {
        userId = json["userId"].stringValue
        fullName = json["fullName"].stringValue
        userType = json["userType"].stringValue
        email = json["email"].stringValue
        mobile = json["mobile"].stringValue
        descriptions = json["descriptions"].stringValue
        address = json["address"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        permanentAddress = json["permanentAddress"].stringValue
        country = json["country"].stringValue
        state = json["state"].stringValue
        city = json["city"].stringValue
        pincode = json["pincode"].stringValue
        newRequest = json["newRequest"].intValue
        totalUnreadMsgCount = json["totalUnreadMsgCount"].intValue
        inProgress = InProgress(json["inProgress"])
    }
}

struct InProgress {
    var orderId = ""
    var orderNumber = ""
    var guideId = ""
    var hireStartDate = ""
    var startTime = ""
    var hireEndDate = ""
    var endTime = ""
    var guideStartDate = ""
    var guideStartTime = ""
    var tripLocation = ""
    var orderStatus = ""

    init(_ json: JSON) {
        orderId = json["orderId"].stringValue
        orderNumber = json["orderNumber"].stringValue
        guideId = json["guideId"].stringValue
        hireStartDate = json["hireStartDate"].stringValue
        startTime = json["startTime"].stringValue
        hireEndDate = json["hireEndDate"].stringValue
        endTime = json["endTime"].stringValue
        guideStartDate = json["guideStartDate"].stringValue
        guideStartTime = json["guideStartTime"].stringValue
        tripLocation = json["tripLocation"].stringValue
        orderStatus = json["orderStatus"].stringValue
    }
}
