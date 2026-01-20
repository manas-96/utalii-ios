//
//  NotificationListModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 02/12/22.
//

import Foundation
import SwiftyJSON

struct NotificationListModel{
    var status = "0"
        var notiList: [NotiList]?
    var error = ""
        init(_ json: JSON) {
            error = json["error"].stringValue
            status = json["status"].stringValue
            notiList = json["notiList"].arrayValue.map { NotiList($0) }
        }
}
struct NotiList {
    
    var notiId = ""
    var message = ""
    var seen = ""
    var created = ""
    var updated = ""
    
    init(_ json: JSON) {
        notiId = json["notiId"].stringValue
        message = json["message"].stringValue
        seen = json["seen"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
    }
    
}
