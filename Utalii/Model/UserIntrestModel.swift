//
//  UserIntrestModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 08/10/22.
//

import Foundation
import SwiftyJSON

struct UserIntrestModel{
    var status = ""
    var error = ""
    var userId = ""
    var interestList: [InterestList]?

    init(_ json: JSON) {
        status = json["status"].stringValue
        userId = json["userId"].stringValue
        error = json["error"].stringValue
        
        if(json["interestList"].arrayValue.count == 0){
            if(json["languages"].arrayValue.count != 0){
                interestList = json["languages"].arrayValue.map { InterestList($0) }
            }
            else{
                interestList = json["list"].arrayValue.map { InterestList($0) }
            }
        }
        else if(json["languages"].arrayValue.count == 0){
            interestList = json["languages"].arrayValue.map { InterestList($0) }
        }
        else{
            interestList = json["interestList"].arrayValue.map { InterestList($0) }
        }
    }
}

struct InterestList {

    var interestId = ""
    var title = ""
    var created = ""
    var updated = ""

    init(_ json: JSON) {
        interestId = ("\(json["interestId"].intValue)")
        if(json["name"].stringValue == ""){
            title = json["title"].stringValue
        }
        else{
            title = json["name"].stringValue
        }
        created = json["created"].stringValue
        updated = json["updated"].stringValue
         
    }

}
