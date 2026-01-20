//
//  API_Constance.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 07/05/22.
//
//

import Foundation
import Alamofire
import AVFoundation

class APIhandler {
    static let SharedInstance = APIhandler()
    
    // MARK: - API without parameters (GET request)
    func API_WithoutParameters(aurl: String,
                               completeBlock: @escaping (_ response: AnyObject) -> Void,
                               errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = ["x-api-key": KU_AUTHTOKEN]
        print("URL: \(aurl)")
        
        AF.request(aurl, method: .get, headers: HEADER_CONTENT_TYPE)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        // Handle 401 Unauthorized
                        break
                    } else {
                        completeBlock(value as AnyObject)
                    }
                    
                case .failure(let error):
                    var errorDict = [String: Any]()
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 404:
                            errorDict = ["errormsg": "Invalid URL: \(aurl)", "errorCode": httpStatusCode]
                        case 401:
                            // Handle 401 Unauthorized
                            break
                        default:
                            errorDict = ["errormsg": "Server error", "errorCode": httpStatusCode]
                        }
                    } else {
                        if error.isSessionTaskError,
                           let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == -1009 {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Check your internet connection")
                            errorDict = ["errormsg": "Please Check your internet connection"]
                        } else {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Server unreachable please try again later.")
                            errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                                       "Server unreachable please try again later." : error.localizedDescription]
                        }
                    }
                    errorBlock(errorDict as AnyObject)
                }
            }
    }
    
    // MARK: - API with parameters (POST request)
    func API_WithParameters(aurl: String,
                            parameter: Dictionary<String, Any>,
                            completeBlock: @escaping (_ response: AnyObject) -> Void,
                            errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        print("URL: \(aurl) parameter: \(parameter)")
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = ["x-api-key": KU_AUTHTOKEN]
        
        AF.request(aurl, method: .post, parameters: parameter,
                   encoding: URLEncoding.default, headers: HEADER_CONTENT_TYPE)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        // Handle 401 Unauthorized
                        break
                    } else {
                        completeBlock(value as AnyObject)
                    }
                    
                case .failure(let error):
                    var errorDict = [String: Any]()
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 404:
                            errorDict = ["errormsg": "Invalid URL: \(aurl)", "errorCode": httpStatusCode]
                        case 401:
                            // Handle 401 Unauthorized
                            break
                        default:
                            errorDict = ["errormsg": "Server error", "errorCode": httpStatusCode]
                        }
                    } else {
                        if error.isSessionTaskError,
                           let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == -1009 {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Check your internet connection")
                            errorDict = ["errormsg": "Please Check your internet connection"]
                        } else {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Server unreachable please try again later.")
                            errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                                       "Server unreachable please try again later." : error.localizedDescription]
                        }
                    }
                    errorBlock(errorDict as AnyObject)
                }
            }
    }
    
    // MARK: - Twilio API with parameters (POST request with Basic Auth)
    func API_WithParameterss(aurl: String,
                             parameter: Dictionary<String, Any>,
                             completeBlock: @escaping (_ response: AnyObject) -> Void,
                             errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        print("URL: \(aurl) parameter: \(parameter)")
        
        let username = "AC0f0efb446e981a99200b769a4135d5cb"
        let password = "b8860542756575a335f364b2c54f7838"
        let credentials = "\(username):\(password)"
        
        guard let credentialData = credentials.data(using: .utf8) else {
            let errorDict = ["errormsg": "Failed to encode credentials"]
            errorBlock(errorDict as AnyObject)
            return
        }
        
        let base64Credentials = credentialData.base64EncodedString()
        let authHeader = "Basic \(base64Credentials)"
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = [
            "Authorization": authHeader,
            "x-api-key": TWILIO_AUTH
        ]
        
        AF.request(aurl, method: .post, parameters: parameter,
                   encoding: URLEncoding.default, headers: HEADER_CONTENT_TYPE)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        // Handle 401 Unauthorized
                        break
                    } else {
                        completeBlock(value as AnyObject)
                    }
                    
                case .failure(let error):
                    var errorDict = [String: Any]()
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 404:
                            errorDict = ["errormsg": "Invalid URL: \(aurl)", "errorCode": httpStatusCode]
                        case 401:
                            // Handle 401 Unauthorized
                            break
                        default:
                            errorDict = ["errormsg": "Server error", "errorCode": httpStatusCode]
                        }
                    } else {
                        if error.isSessionTaskError,
                           let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == -1009 {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Check your internet connection")
                            errorDict = ["errormsg": "Please Check your internet connection"]
                        } else {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Server unreachable please try again later.")
                            errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                                       "Server unreachable please try again later." : error.localizedDescription]
                        }
                    }
                    errorBlock(errorDict as AnyObject)
                }
            }
    }
    
    // MARK: - Send SMS API with authorization header
    func API_WithSendsmsParameters(aurl: String,
                                   auth: String,
                                   parameter: Dictionary<String, Any>,
                                   completeBlock: @escaping (_ response: AnyObject) -> Void,
                                   errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        print("URL: \(aurl) parameter: \(parameter)")
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = [
            "x-api-key": KU_AUTHTOKEN,
            "Authorization": auth
        ]
        
        AF.request(aurl, method: .post, parameters: parameter,
                   encoding: URLEncoding.default, headers: HEADER_CONTENT_TYPE)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    // Note: Both 401 and success cases now call completeBlock
                    completeBlock(value as AnyObject)
                    
                case .failure(let error):
                    var errorDict = [String: Any]()
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 404:
                            errorDict = ["errormsg": "Invalid URL: \(aurl)", "errorCode": httpStatusCode]
                        case 401:
                            // Handle 401 Unauthorized - you might want to add specific handling here
                            break
                        default:
                            errorDict = ["errormsg": "Server error", "errorCode": httpStatusCode]
                        }
                    } else {
                        if error.isSessionTaskError,
                           let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == -1009 {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Check your internet connection")
                            errorDict = ["errormsg": "Please Check your internet connection"]
                        } else {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Server unreachable please try again later.")
                            errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                                       "Server unreachable please try again later." : error.localizedDescription]
                        }
                    }
                    errorBlock(errorDict as AnyObject)
                }
            }
    }
    
    // MARK: - Upload single image with parameters
    func Api_withImageAndParameters(aWebServiceName: String?,
                                    aDictParam: [String: Any],
                                    aImag: UIImage?,
                                    imgParameter: String,
                                    completeBlock: @escaping (_ response: AnyObject) -> Void,
                                    errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        guard let passingURL = aWebServiceName else {
            let errorDict = ["errormsg": "Invalid URL"]
            errorBlock(errorDict as AnyObject)
            return
        }
        
        print("Upload URL: \(passingURL)")
        print("Parameters: \(aDictParam)")
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = ["x-api-key": KU_AUTHTOKEN]
        
        AF.upload(multipartFormData: { multipartFormData in
            // Add text parameters
            for (key, value) in aDictParam {
                if let stringValue = value as? String,
                   let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else if let intValue = value as? Int {
                    let stringValue = "\(intValue)"
                    if let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
            
            // Add image
            if let image = aImag,
               let imageData = image.jpegData(compressionQuality: 0.75) {
                let fileName = "\(Date().timeIntervalSince1970).jpg"
                multipartFormData.append(imageData, withName: imgParameter,
                                        fileName: fileName, mimeType: "image/jpg")
                print("Added image: \(fileName)")
            }
            
        }, to: passingURL, method: .post, headers: HEADER_CONTENT_TYPE)
        .responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let statusCode = response.response?.statusCode, statusCode == 401 {
                    // Handle 401 Unauthorized
                } else {
                    completeBlock(value as AnyObject)
                }
                
            case .failure(let error):
                var errorDict = [String: Any]()
                
                if error.isSessionTaskError,
                   let underlyingError = error.underlyingError as? NSError,
                   underlyingError.code == -1009 {
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName,
                                                             aMsg: "Please Check your internet connection")
                    errorDict = ["errormsg": "Please Check your internet connection"]
                } else {
                    errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                               "Server unreachable please try again later." : error.localizedDescription]
                }
                errorBlock(errorDict as AnyObject)
            }
        }
    }
    
    // MARK: - Upload multiple images with parameters
    func Api_withImageAndParameters(aWebServiceName: String?,
                                    aDictParam: [String: Any],
                                    aImag: UIImage?,
                                    aImag2: UIImage?,
                                    aImag3: UIImage?,
                                    imgParameter: String,
                                    imgParameter2: String,
                                    imgParameter3: String,
                                    completeBlock: @escaping (_ response: AnyObject) -> Void,
                                    errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        guard let passingURL = aWebServiceName else {
            let errorDict = ["errormsg": "Invalid URL"]
            errorBlock(errorDict as AnyObject)
            return
        }
        
        print("Upload URL: \(passingURL)")
        print("Parameters: \(aDictParam)")
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = ["x-api-key": KU_AUTHTOKEN]
        
        AF.upload(multipartFormData: { multipartFormData in
            // Add text parameters
            for (key, value) in aDictParam {
                if let stringValue = value as? String,
                   let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else if let intValue = value as? Int {
                    let stringValue = "\(intValue)"
                    if let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
            
            // Add first image
            if let image = aImag,
               let imageData = image.jpegData(compressionQuality: 0.5) {
                let fileName = "\(Date().timeIntervalSince1970)_1.jpg"
                multipartFormData.append(imageData, withName: imgParameter,
                                        fileName: fileName, mimeType: "image/jpg")
            }
            
            // Add second image
            if let image2 = aImag2,
               let imageData2 = image2.jpegData(compressionQuality: 0.5) {
                let fileName = "\(Date().timeIntervalSince1970)_2.jpg"
                multipartFormData.append(imageData2, withName: imgParameter2,
                                        fileName: fileName, mimeType: "image/jpg")
            }
            
            // Add third image
            if let image3 = aImag3,
               let imageData3 = image3.jpegData(compressionQuality: 0.5) {
                let fileName = "\(Date().timeIntervalSince1970)_3.jpg"
                multipartFormData.append(imageData3, withName: imgParameter3,
                                        fileName: fileName, mimeType: "image/jpg")
            }
            
        }, to: passingURL, method: .post, headers: HEADER_CONTENT_TYPE)
        .responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let statusCode = response.response?.statusCode, statusCode == 401 {
                    // Handle 401 Unauthorized
                } else {
                    completeBlock(value as AnyObject)
                }
                
            case .failure(let error):
                var errorDict = [String: Any]()
                
                if error.isSessionTaskError,
                   let underlyingError = error.underlyingError as? NSError,
                   underlyingError.code == -1009 {
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName,
                                                             aMsg: "Please Check your internet connection")
                    errorDict = ["errormsg": "Please Check your internet connection"]
                } else {
                    errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                               "Server unreachable please try again later." : error.localizedDescription]
                }
                errorBlock(errorDict as AnyObject)
            }
        }
    }
    
    // MARK: - Upload image and video with parameters
    func Api_withImageVideoAndParameters(aWebServiceName: String?,
                                         videoName: String,
                                         video: URL?,
                                         aDictParam: [String: Any],
                                         aImag: UIImage?,
                                         imgParameter: String,
                                         completeBlock: @escaping (_ response: AnyObject) -> Void,
                                         errorBlock: @escaping (_ error: AnyObject) -> Void) {
        
        guard let passingURL = aWebServiceName else {
            let errorDict = ["errormsg": "Invalid URL"]
            errorBlock(errorDict as AnyObject)
            return
        }
        
        print("Upload URL: \(passingURL)")
        print("Parameters: \(aDictParam)")
        
        let HEADER_CONTENT_TYPE: HTTPHeaders = ["x-api-key": KU_AUTHTOKEN]
        
        AF.upload(multipartFormData: { multipartFormData in
            // Add text parameters
            for (key, value) in aDictParam {
                if let stringValue = value as? String,
                   let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            // Add image
            if let image = aImag,
               let imageData = image.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(imageData, withName: imgParameter,
                                        fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            // Add video
            if let videoURL = video {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    let randomInt = Int.random(in: 1..<5000)
                    let userID = UserDefaults.standard.string(forKey: KU_USERID) ?? "unknown"
                    let fileName = "\(randomInt)\(userID)video.mp4"
                    
                    multipartFormData.append(videoData, withName: "file",
                                            fileName: fileName, mimeType: "video/mp4")
                } catch {
                    print("Failed to load video data: \(error)")
                }
            }
            
        }, to: passingURL, method: .post, headers: HEADER_CONTENT_TYPE)
        .responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let statusCode = response.response?.statusCode, statusCode == 401 {
                    // Handle 401 Unauthorized
                } else {
                    completeBlock(value as AnyObject)
                }
                
            case .failure(let error):
                var errorDict = [String: Any]()
                
                if error.isSessionTaskError,
                   let underlyingError = error.underlyingError as? NSError,
                   underlyingError.code == -1009 {
                    // No alert here as requested by original code
                    errorDict = ["errormsg": "Please Check your internet connection"]
                } else {
                    errorDict = ["errormsg": error.localizedDescription.isEmpty ?
                               "Server unreachable please try again later." : error.localizedDescription]
                }
                errorBlock(errorDict as AnyObject)
            }
        }
    }
}
