//
//  MyTourModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 25/11/22.
//

import Foundation
import SwiftyJSON

struct MyTourModel{
    var status = ""
    var list: [MyTourModelList]?
    var error = ""
    
    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        if(json["list"].arrayValue.count > 0){
            list = json["list"].arrayValue.map { MyTourModelList($0) }
        }
        else{
            list = json["serviceRequestList"].arrayValue.map { MyTourModelList($0) }
        }
    }
}
struct MyTourModelList {
    
    var orderId = ""
    var orderNumber = ""
    var travellerUserId = ""
    var travellerfullName = ""
    var travellerPic = ""
    var guideId = ""
    var guidefullName = ""
    var guidePic = ""
    var hireStartDate = ""
    var startTime = ""
    var hireEndDate = ""
    var endTime = ""
    var guideStartDate = ""
    var guideStartTime = ""
    var tripLocation = ""
    var lat = ""
    var lon = ""
    var orderStatus = ""
    var created = ""
    var updated = ""
    var txnId = ""
    var paymentStatus = ""
    var paymentDate = ""
    var paidAmountCurrency = ""
    var currencySymbol = ""
    var paidAmount = ""
    var unreadMsgCount = 0
    
    init(_ json: JSON) {
        orderId = json["orderId"].stringValue
        orderNumber = json["orderNumber"].stringValue
        travellerUserId = json["travellerUserId"].stringValue
        travellerfullName = json["travellerfullName"].stringValue
        travellerPic = json["travellerPic"].stringValue
        guideId = json["guideId"].stringValue
        guidefullName = json["guidefullName"].stringValue
        guidePic = json["guidePic"].stringValue
        hireStartDate = json["hireStartDate"].stringValue
        startTime = json["startTime"].stringValue
        hireEndDate = json["hireEndDate"].stringValue
        endTime = json["endTime"].stringValue
        guideStartDate = json["guideStartDate"].stringValue
        guideStartTime = json["guideStartTime"].stringValue
        tripLocation = json["tripLocation"].stringValue
        lat = json["lat"].stringValue
        lon = json["lon"].stringValue
        orderStatus = json["orderStatus"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
        txnId = json["txnId"].stringValue
        paymentStatus = json["paymentStatus"].stringValue
        paymentDate = json["paymentDate"].stringValue
        paidAmountCurrency = json["paidAmountCurrency"].stringValue
        currencySymbol = json["currencySymbol"].stringValue
        paidAmount = json["paidAmount"].stringValue
        unreadMsgCount = json["unreadMsgCount"].intValue
    }
    
}
