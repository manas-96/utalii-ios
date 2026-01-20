//
//  ChatUserModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 02/12/22.
//

import Foundation
import SwiftyJSON

struct ChatUserModel{
    var status = ""
    var list: [ChatUserList]?
    var error = ""
    
    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        list = json["list"].arrayValue.map { ChatUserList($0) }
    }
}

struct ChatUserList {

    var created = ""
    var pic = ""
    var lastMsgDateTime = ""
    var fullName = ""
    var unreadMsgCount: Int?
    var emailId = ""
    var userId = ""
    var lastMsg = ""
    var orderInfo: OrderInfo?

    init(_ json: JSON) {
        created = json["created"].stringValue
        pic = json["pic"].stringValue
        lastMsgDateTime = json["lastMsgDateTime"].stringValue
        fullName = json["fullName"].stringValue
        unreadMsgCount = json["unreadMsgCount"].intValue
        emailId = json["emailId"].stringValue
        userId = json["userId"].stringValue
        lastMsg = json["lastMsg"].stringValue
        orderInfo = OrderInfo(json["orderInfo"])
    }

}
struct OrderInfo {

    var orderId = ""
    var tripLocation = ""
    var guideStartDate = ""
    var orderNumber = ""
    var lat = ""
    var endTime = ""
    var orderStatus = ""
    var hireStartDate = ""
    var hireEndDate = ""
    var startTime = ""
    var lon = ""
    var guideStartTime = ""

    init(_ json: JSON) {
        orderId = json["orderId"].stringValue
        tripLocation = json["tripLocation"].stringValue
        guideStartDate = json["guideStartDate"].stringValue
        orderNumber = json["orderNumber"].stringValue
        lat = json["lat"].stringValue
        endTime = json["endTime"].stringValue
        orderStatus = json["orderStatus"].stringValue
        hireStartDate = json["hireStartDate"].stringValue
        hireEndDate = json["hireEndDate"].stringValue
        startTime = json["startTime"].stringValue
        lon = json["lon"].stringValue
        guideStartTime = json["guideStartTime"].stringValue
    }

}
