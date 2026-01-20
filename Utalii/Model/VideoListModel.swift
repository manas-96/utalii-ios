//
//  VideoListModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 23/11/22.
//

import Foundation
import SwiftyJSON

struct VideoListModel{
    
    var status = ""
    var error = ""
    var list: [VideoList]?

    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        list = json["list"].arrayValue.map { VideoList($0) }
    }
}

struct VideoList {

    var videoId = ""
    var title = ""
    var video = ""
    var coverImg = ""
    var siteLocation = ""
    var lat = ""
    var lon = ""
    var created = ""
    var updated = ""
 
    init(_ json: JSON) {
        videoId = json["videoId"].stringValue
        title = json["title"].stringValue
        video = json["video"].stringValue
        coverImg = json["coverImg"].stringValue
        siteLocation = json["siteLocation"].stringValue
        lat = json["lat"].stringValue
        lon = json["lon"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
    }

}
