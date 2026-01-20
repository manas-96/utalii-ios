//
//  ChatConversationModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 02/12/22.
//

import Foundation
import SwiftyJSON

struct ChatConversationModel{
    var status = ""
        var chatList: [ChatList]?

        init(_ json: JSON) {
            status = json["status"].stringValue
            chatList = json["chatList"].arrayValue.map { ChatList($0) }
        }
}
struct ChatList {

    var chatId = ""
    var senderId = ""
    var receiverId = ""
    var message = ""
    var seen = ""
    var created = ""

    init(_ json: JSON) {
        chatId = json["chatId"].stringValue
        senderId = json["senderId"].stringValue
        receiverId = json["receiverId"].stringValue
        message = json["message"].stringValue
        seen = json["seen"].stringValue
        created = json["created"].stringValue
    }

}
