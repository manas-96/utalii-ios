//
//  Constant.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 07/05/22.
//
import Foundation
import UIKit

//MARK:- API Collection
 // https://www.getpostman.com/collections/ecc0dafe972e2c6d2a4b
//MARK:- Live Url

let userName1 = "AC0f0efb446e981a99200b769a4135d5cb"
let password1 = "813aa216979a574001b5fa33f75568c8"
let fromNumber = "+19033205901"
 
let countryCode = "+1"
let catacterSplite = 2

let lockDate = "2022-07-29"

let showLog = true

var marrGuideDetailModel : GuideDetailModel!
var marrGuideDetails1 : GuideDetails!


//MARK:- Local Url
let KU_AUTHTOKEN = "dffabc2b086faf74c8512d408c021a4f"
let TWILIO_AUTH = "b8860542756575a335f364b2c54f7838"

let BASEURL = "https://utaliiworld.com/restapi/api/"
let IMAGEURL = ""
 

let API_Login = BASEURL + "login"
let API_Profile = BASEURL + "profilePic"
let API_SignUp = BASEURL + "signup"
let API_ForgotPassword = BASEURL + "recoveryPassword"
let API_GetOTPForgotPassword = BASEURL + "getOtp"
let API_UserInfo = BASEURL + "userInfo"
let API_GuideList = BASEURL + "guideList"
let API_SendPushMsgFCM = BASEURL + "sendPushMsgFCM"
let API_AddFCMToken = BASEURL + "addUserFirebase"


let API_GuideDetail = BASEURL + "guideDetails"
let API_MyOrder = BASEURL + "myOrder"
let API_MyOrderList = BASEURL + "orderList"
let API_ServiceRequestList = BASEURL + "serviceRequestList"

let API_UpdateProfile = BASEURL + "updateProfile"
let API_UpdateGuideProfile = BASEURL + "updateGuideProfile"

let API_IntrestList = BASEURL + "interestList"

let API_UserInterestList = BASEURL + "userInterestList"
let API_Languages = BASEURL + "languages"
let API_ChangePassword = BASEURL + "changePassword"

let API_GuideDashboard = BASEURL + "dashboard"
let API_ADDShortVideo = BASEURL + "addShortVideo"
let API_GOONLINEOFFLINE = BASEURL + "updateAvailability"
//let API_UserInfo = BASEURL + "userInfo"

let API_DefaultPackage = BASEURL + "packages"
let API_SpecialPackage = BASEURL + "specialPackageList"
let API_AddSpecialPackage = BASEURL + "specialPackage"
let API_UpdatespecialPackage = BASEURL + "specialPackageUpdate"
let API_DeleteSpcialPackage = BASEURL + "specialPackageDelete"

let API_OrderDetail = BASEURL + "orderDetails"
let API_ReviewList = BASEURL + "reviewList"
let API_AddReview = BASEURL + "addEditReview"
let API_AddReview_Guide = BASEURL + "addEditReviewTourist"
let API_ReviewList_guide = BASEURL + "reviewListForGuide"


let API_VideoList = BASEURL + "videoList"
let API_NearByVideo = BASEURL + "nearByVideoList"
let API_DeleteVideo = BASEURL + "deleteShortVideo"

let API_AddOrder = BASEURL + "addOrder"
let API_GenrateStripeLink = BASEURL + "stripe-payment"
let API_MyTransaction = BASEURL + "myOrder"
let API_UpdateTravellerProfile = BASEURL + "updateProfile"
let API_ChatUserList = BASEURL + "chatUserList"
let API_ChatHistory = BASEURL + "chatHistory"
let API_SendMessage = BASEURL + "sendMessage"

let API_OrderList = BASEURL + "orderList"

let API_StartEndTour = BASEURL + "startEndTour"
let API_AddEditLocation = BASEURL + "addEditCurrentLoc"
let API_SOSREQUEST = BASEURL + "sosRequest"

let API_ADDBANCKINFO = BASEURL + "addBankInfo"
let API_EDITBANKINFO = BASEURL + "editBankInfo"
let API_DELETEBANK = BASEURL + "deleteBank"
let API_NOTIFICATIONLIST = BASEURL + "notificationList"
let API_MARKASALLREAD = BASEURL + "markAsReadNoti"
let API_DELETENOTIFICATION = BASEURL + "deleteNotification"
let API_StripeConnect = BASEURL + "stripeConnect"
let API_StripeConnectDetails = BASEURL + "userStripeInfo"

let API_StripeConnectCheck = BASEURL + "checkMobileStripeConnect"
let API_Get_Otp = BASEURL + "getSMSOtp"



//userStripeInfo

let API_SendSMS = "https://api.twilio.com/2010-04-01/Accounts/ACb2d55c9db3c2e6472dea8694a75b0d7e/Messages.json"

//MARK:- Common Fonts
let VerySmallFont  : CGFloat = 8

let SmallFont  : CGFloat = 13
let MediumFont  : CGFloat = 14
let LargeFont : CGFloat = 17
 

//MARK:- Color
var touristMainVC = TouristMainVC()
var guideMainVC = GuideMainVC()

//MARK:- Common Fonts
let Bold = "Poppins-Medium"
let Medium = "Poppins-Regular"
let Light = "Poppins-Regular"
  
//SFProText-Bold

//MARK:- User Default
let KU_ISLOGIN = "ISLOGIN"
let KU_USERID = "USERID"
let KU_USERTYPE = "USERTYPE"
let KU_FULLNAME = "FULLNAME"
let KU_EMAILID = "EMAILID"
let KU_COUNTRYNAMECODE = "COUNTRYNAMECODE"
let KU_MOBILENO = "MOBILENO"
let KU_COUNTRYNAMECODEEMG = "COUNTRYNAMECODEEMG"
let KU_EMERGENCYNUMBER = "EMERGENCYNUMBER"
let KU_PROFILEPIC = "PROFILEPIC"
let KU_COVERPiIC = "COVERPiIC"
let KU_MINIMUMCHARGE = "MINIMUMCHARGE"
let KU_CURRENCTTYPE = "CURRENCTTYPE"
let KU_CURRENCYSYMBOL = "CURRENCYSYMBOL"
let KU_LICENSE = "LICENSE"
let KU_ISAVAILABILITY = "ISAVAILABILITY"
let KU_TRIPCOMPLETED = "TRIPCOMPLETED"
let KU_BANKINFOSTATUS = "BANKINFOSTATUS"
let KU_STRIPECONNECTSTATUS = "STRIPECONNECTSTATUS"
let KU_STRIPEACCOUNTID = "STRIPEACCOUNTID"

let KU_BANKID = "BANKID"
let KU_ACCOUNTHOLDERNAME = "ACCOUNTHOLDERNAME"
let KU_ACCOUNTNUMBER = "ACCOUNTNUMBER"
let KU_ABANUMBER = "ABANUMBER"
let KU_BANKNAME = "BABKNAME"
let KU_BANKADDRESS = "BANKADDRESS"
let KU_CREATED = "CREATED"
let KU_UPDATED = "UPDATED"
let KU_PASSWORD = "PASSWORD"
let KU_ADDRESS = "ADDRESS"
let KU_LOGINLATITUDE = "LOGINLATITUDE"
let KU_LOGINLOGITUDE = "LOGINLOGITUDE"

let KU_ISGUIDESTARTTOUR = "ISGUIDESTARTTOUR"
let KU_GUIDEORDERID = "GUIDEORDERID"

let KU_ISTURISTSTARTTOUR = "ISGUIDESTARTTOUR"
let KU_TURISTORDERID = "GUIDEORDERID"

let KU_USERRESPONCE = "KU_USERRESPONCE"
let KU_DESCRIPTION = "KU_DESCRIPTION"

let KU_STREETADDRESS = "KU_STREETADDRESS"
let KU_CITY = "KU_CITY"
let KU_STATE = "KU_STATE"
let KU_COUNTRY = "KU_COUNTRY"
let POSTALCODE = "POSTALCODE"

//MARK:- StoryBoard
let storyBoard = (UIStoryboard.init(name: "Main", bundle: Bundle.main))
let touristStoryBoard = (UIStoryboard.init(name: "Tourist", bundle: Bundle.main))
let guideStoryBoard = (UIStoryboard.init(name: "Guide", bundle: Bundle.main))

let K_AppDelegate = UIApplication.shared.delegate as! AppDelegate

//Colors
let purple_200 : UIColor = UIColor(named: "purple_200")!
let purple_500 : UIColor = UIColor(named: "purple_500")!
let purple_700 : UIColor = UIColor(named: "purple_700")!
let teal_200 : UIColor = UIColor(named: "teal_200")!
let teal_700 : UIColor = UIColor(named: "teal_700")!

let black : UIColor = UIColor(named: "black")!
let white : UIColor = UIColor(named: "white")!

let blackDark : UIColor = UIColor(named: "blackDark")!


let colorPrimary : UIColor = UIColor(named: "colorPrimary")!
let colorPrimaryDark : UIColor = UIColor(named: "colorPrimaryDark")!
let colorAccent : UIColor = UIColor(named: "colorAccent")!
let colorText : UIColor = UIColor(named: "colorText")!
let colorWhite : UIColor = UIColor(named: "colorWhite")!
let colorGray : UIColor = UIColor(named: "colorGray")!
let colorLightGray : UIColor = UIColor(named: "colorLightGray")!
let colorBlue : UIColor = UIColor(named: "colorBlue")!
let colorRed : UIColor = UIColor(named: "colorRed")!
let colorRed1 : UIColor = UIColor(named: "colorRed1")!
let colorTransparent : UIColor = UIColor(named: "colorTransparent")!
let colorGreen : UIColor = UIColor(named: "colorGreen")!
let colorAquaMarine : UIColor = UIColor(named: "colorAquaMarine")!
let colorLightYellow : UIColor = UIColor(named: "colorLightYellow")!
let colorLightGrayTrans : UIColor = UIColor(named: "colorLightGrayTrans")!
let colorLightGrayTrans1 : UIColor = UIColor(named: "colorLightGrayTrans1")!
let transparent : UIColor = UIColor(named: "transparent")!
let background1 : UIColor = UIColor(named: "background")!
let colorBluetr : UIColor = UIColor(named: "colorBluetr")!

