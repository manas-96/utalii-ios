//
//  LoginModel.swift
//  Utalii
//
//  Created by Mitul Talpara on 06/10/22.
//

import Foundation
import SwiftyJSON
 
struct LoginModelNew{
    var status = ""
    var error = ""
    var userId = ""
    var personalInfo: PersonalInfo?
    var message = ""
    var otp = ""
    var isAvailability = ""
    var details: DetailsNew?
    var orderId = ""
    
    init(_ json: JSON) {
        orderId = json["orderId"].stringValue
        otp = json["otp"].stringValue
        message = json["message"].stringValue
        userId = json["userId"].stringValue
        status = json["status"].stringValue
        error = json["error"].stringValue
        isAvailability = json["isAvailability"].stringValue
        personalInfo = PersonalInfo(json["personalInfo"])
        details = DetailsNew(json["details"])
    }
}

struct PersonalInfoNew {
    
    var userId = ""
    var userType = ""
    var fullName = ""
    var emailId = ""
    var countryNameCode = ""
    var mobileNo = ""
    var countryNameCodeEmg = ""
    var emergencyNumber = ""
    var profilePic = ""
    var coverpic = ""
    var minimumCharge = ""
    var currencyType = ""
    var currencySymbol = ""
    var license = ""
    var isAvailability = ""
    var tripCompleted = ""
    var bankInfoStatus = ""
    var bankInfo: BankInfoNew?
    var address = ""
    var latitude = ""
    var longitude = ""
    
    init(_ json: JSON) {
        longitude = json["longitude"].stringValue
        latitude = json["latitude"].stringValue
        address = json["address"].stringValue
        userId = json["userId"].stringValue
        userType = json["userType"].stringValue
        fullName = json["fullName"].stringValue
        emailId = json["emailId"].stringValue
        countryNameCode = json["countryNameCode"].stringValue
        mobileNo = json["mobileNo"].stringValue
        countryNameCodeEmg = json["countryNameCodeEmg"].stringValue
        emergencyNumber = json["emergencyNumber"].stringValue
        profilePic = json["profilePic"].stringValue
        coverpic = json["coverpic"].stringValue
        minimumCharge = json["minimumCharge"].stringValue
        currencyType = json["currencyType"].stringValue
        currencySymbol = json["currencySymbol"].stringValue
        license = json["license"].stringValue
        isAvailability = json["isAvailability"].stringValue
        tripCompleted = json["tripCompleted"].stringValue
        bankInfoStatus = json["bankInfoStatus"].stringValue
        bankInfo = BankInfoNew(json["bankInfo"])
    }
    
}

struct BankInfoNew {
    
    var bankId = ""
    var accountHolderName = ""
    var accountNumber = ""
    var abaNumber = ""
    var bankName = ""
    var bankAddress = ""
    var created = ""
    var updated = ""
    
    init(_ json: JSON) {
        bankId = json["bankId"].stringValue
        accountHolderName = json["accountHolderName"].stringValue
        accountNumber = json["accountNumber"].stringValue
        abaNumber = json["abaNumber"].stringValue
        bankName = json["bankName"].stringValue
        bankAddress = json["bankAddress"].stringValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
    }
    
}

struct DetailsNew {

    var userId = ""
    var fullName = ""
    var userType = ""
    var email = ""
    var mobile = ""
    var address = ""
    var latitude = ""
    var longitude = ""
    var profilePic = ""
    var ongoing = ""
    var inProgress: InProgress?

    init(_ json: JSON) {
        userId = json["userId"].stringValue
        fullName = json["fullName"].stringValue
        userType = json["userType"].stringValue
        email = json["email"].stringValue
        mobile = json["mobile"].stringValue
        address = json["address"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        profilePic = json["profilePic"].stringValue
        ongoing = json["ongoing"].stringValue
        inProgress = InProgress(json["inProgress"])
    }

}
struct InProgressTouristNew {

    var orderId = ""
    var orderNumber = ""
    var guideId = ""
    var hireStartDate = ""
    var startTime = ""
    var hireEndDate = ""
    var endTime = ""
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
        guideStartTime = json["guideStartTime"].stringValue
        tripLocation = json["tripLocation"].stringValue
        orderStatus = json["orderStatus"].stringValue
    }

}
