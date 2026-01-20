//
//  OrderDetailModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 25/11/22.
//

import Foundation
import SwiftyJSON

struct OrderDetailModel{
    
    var status = ""
    var details: OrderDetails?
    var error = ""
    
    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        details = OrderDetails(json["details"])
    }
}

struct OrderDetails {

    var orderId = ""
    var orderNumber = ""
    var guideId = ""
    var guidefullName = ""
    var guideMobile = ""
    var guidePic = ""
    var avgRating = ""
    var totalReviews = ""
    var languageKnown = ""
    var placesKnown = ""
    var type = ""
    var packageId = ""
    var packageName = ""
    var packagePrice = ""
    var packageType = ""
    var currency = ""
    var currencySymbol = ""
    var location = ""
    var latitude = ""
    var longitude = ""
    var placesCovered = ""
    var startTime = ""
    var estimatedTime = ""
    var duration = ""
    var packageDescription = ""
    var travellerUserId = ""
    var travellerfullName = ""
    var travellerMobile = ""
    var emergencyNumber = ""
    var travellerPic = ""
    var hireStartDate = ""
    var hireStartTime = ""
    var hireEndDate = ""
    var hireEndTime = ""
    var guideStartDate = ""
    var guideStartTime = ""
    var tripLocation = ""
    var lat = ""
    var lon = ""
    var orderStatus = ""
    var created = ""
    var updated = ""
    var txnId = ""
    var paidAmount = ""
    var paidAmountCurrency = ""
    var charge = ""
    var paymentStatus = ""
    var paymentDate = ""
    var SOSActiveStatus = ""
    var unreadMsgCount = 0
    var defaultPackageDuration = ""
    var defaultPackageEndTime = ""
    var defaultPackageStartTime = ""
    var startTourOTP = ""
    init(_ json: JSON) {
        orderId = json["orderId"].stringValue
        orderNumber = json["orderNumber"].stringValue
        guideId = json["guideId"].stringValue
        guidefullName = json["guidefullName"].stringValue
        guideMobile = json["guideMobile"].stringValue
        guidePic = json["guidePic"].stringValue
        avgRating = json["avgRating"].stringValue
        totalReviews = json["totalReviews"].stringValue
        languageKnown = json["languageKnown"].stringValue
        placesKnown = json["placesKnown"].stringValue
        type = json["type"].stringValue
        packageId = json["packageId"].stringValue
        packageName = json["packageName"].stringValue
        packagePrice = json["packagePrice"].stringValue
        packageType = json["packageType"].stringValue
        currency = json["currency"].stringValue
        currencySymbol = json["currencySymbol"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        placesCovered = json["placesCovered"].stringValue
        startTime = json["startTime"].stringValue
        estimatedTime = json["estimatedTime"].stringValue
        duration = json["duration"].stringValue
        packageDescription = json["packageDescription"].stringValue
        travellerUserId = json["travellerUserId"].stringValue
        travellerfullName = json["travellerfullName"].stringValue
        travellerMobile = json["travellerMobile"].stringValue
        emergencyNumber = json["emergencyNumber"].stringValue
        travellerPic = json["travellerPic"].stringValue
        hireStartDate = json["hireStartDate"].stringValue
        hireStartTime = json["hireStartTime"].stringValue
        hireEndDate = json["hireEndDate"].stringValue
        hireEndTime = json["hireEndTime"].stringValue
        guideStartDate = json["guideStartDate"].stringValue
        guideStartTime = json["guideStartTime"].stringValue
        tripLocation = json["tripLocation"].stringValue
        lat = json["lat"].stringValue
        lon = json["lon"].stringValue
        orderStatus = json["orderStatus"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
        txnId = json["txnId"].stringValue
        paidAmount = json["paidAmount"].stringValue
        paidAmountCurrency = json["paidAmountCurrency"].stringValue
        charge = json["charge"].stringValue
        paymentStatus = json["paymentStatus"].stringValue
        paymentDate = json["paymentDate"].stringValue
        SOSActiveStatus = json["SOSActiveStatus"].stringValue
        unreadMsgCount = json["unreadMsgCount"].intValue
        defaultPackageDuration = json["defaultPackageDuration"].stringValue
        defaultPackageEndTime = json["defaultPackageEndTime"].stringValue
        defaultPackageStartTime = json["defaultPackageStartTime"].stringValue
        startTourOTP = json["startTourOTP"].stringValue

    }

}
