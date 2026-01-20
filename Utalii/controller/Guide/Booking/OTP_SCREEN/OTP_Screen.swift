//
//  OTP_Screen.swift
//  Utalii
//
//  Created by IOSKOL on 28/10/23.
//

import UIKit
import AEOTPTextField
import SwiftyJSON
import NBBottomSheet
import SwiftyJSON
protocol Otp_Verification:AnyObject {
    func otpVerified(otp_type:String)
}




struct otp_details{
    var otp_type:String = ""
    var tourist_id:String = ""
    var order_id:String = ""
    var otp_to_send = ""
}
enum Otp_types{
    case Start_otp,End_otp
}
struct OtpVerificationResponse: Codable {
    let status: String
    let message: String?
    let error:String?
}
class OTP_Screen: UIViewController, AEOTPTextFieldDelegate{
    var otp_type = Otp_types.self
    var otp_data = otp_details()
    var user_id = ""
    var OtpType = ""
    var mobilenumber = ""
    var Otptoverify = ""
    var countryNameCode = ""

    weak var delegate: Otp_Verification?
    

    func didUserFinishEnter(the code: String) {
        print(code)
        //self.navigationController?.popViewController(animated: true)
        otp_data.otp_to_send = code
        self.Otptoverify = code
        
        if(OtpType == "Mobile"){
            verifyOtpPhone()
        }else{
            verifyOtp()
        }
    }
    
    @IBOutlet weak var otp_text: AEOTPTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        otp_text.otpDelegate = self
        otp_text.otpFontSize = 20
        otp_text.configure(with: 4)
        otp_text.otpFilledBorderColor = .blue
        getOtp()
      //  otp_data.tourist_id = "374"
      //  otp_data.otp_type = "start_tour_otp"
      //  otp_data.order_id = "109"
        
        // Do any additional setup after loading the view.
    }
    func getOtp(){

        let dict = ["userId":self.user_id]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_Get_Otp, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                
                print(" received otp:-----\(dict)  -- \(responseObj)")
                
            }
            print(JSON(responseObj))
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    @IBAction func back_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OTP_Screen{
    func verifyOtp() {
        // Define the URL for the API endpoint
        print("API CALLED")
        IJProgressView.shared.showProgressView()
        let apiUrl = URL(string: "https://utaliiworld.com/restapi/api/verifyOtp")!
        // Create the request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        // Set the headers
        request.setValue("dffabc2b086faf74c8512d408c021a4f", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Create the POST parameters as a dictionary
        let parameters: [String: Any] = [
            "tourist_id": otp_data.tourist_id,
            "order_id": otp_data.order_id,
            "otp_type": otp_data.otp_type,
            "otp": otp_data.otp_to_send
        ]
        print("Sent PArameteres are \(parameters)")
        do {
            // Serialize the parameters as JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            // Attach the JSON data to the request
            request.httpBody = jsonData
            // Create a URLSession task for the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    IJProgressView.shared.hideProgressView()

                } else if let data = data {
                    IJProgressView.shared.hideProgressView()
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let otpVerificationResponse = try decoder.decode(OtpVerificationResponse.self, from: data)
                        print("API CALLED 2")

                        if otpVerificationResponse.status == "1" {
                            print("OTP Verification Successful")
                            print("Message: \(otpVerificationResponse.message ?? "No Value")")
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: otpVerificationResponse.message ?? "Please check Otp Provided")
                                self.delegate?.otpVerified(otp_type: self.otp_data.otp_type)
                                
                            }
                        } else {
                            print("OTP Verification Failed")
                            print("Message: \(otpVerificationResponse.error ?? "Error")")
                            DispatchQueue.main.async {
                                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: otpVerificationResponse.error ?? "Please check Otp Provided")
                                self.otp_text.clearOTP()
                               // self.delegate?.otpVerified(otp_type: self.otp_data.otp_type)
                            }
                            

                        }
                    } catch {
                        print("Error decoding API response: \(error)")
                        DispatchQueue.main.async {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: error.localizedDescription )
                            self.otp_text.clearOTP()
                            //self.delegate?.otpVerified(otp_type: "NA")
                        }

                    }
                    // You can handle the response data here
                }
            }
            // Start the URLSession task
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
            IJProgressView.shared.hideProgressView()

        }
    }
    
    
    func verifyOtpPhone() {
        // Define the URL for the API endpoint
        print("API CALLED")
        IJProgressView.shared.showProgressView()
        let apiUrl = URL(string: "https://utaliiworld.com/restapi/api/verifyMobileOtp")!
        // Create the request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        // Set the headers
        request.setValue("dffabc2b086faf74c8512d408c021a4f", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Create the POST parameters as a dictionary
        let parameters: [String: Any] = [
            "userId": self.user_id,
            "mobile": self.mobilenumber,
            "otp": self.Otptoverify,
            "countryNameCode" : self.countryNameCode
        ]
        print("Sent PArameteres are \(parameters)")
        do {
            // Serialize the parameters as JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            // Attach the JSON data to the request
            request.httpBody = jsonData
            // Create a URLSession task for the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    IJProgressView.shared.hideProgressView()

                } else if let data = data {
                    IJProgressView.shared.hideProgressView()
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let otpVerificationResponse = try decoder.decode(OtpVerificationResponse.self, from: data)
                        print("API CALLED 2")

                        if otpVerificationResponse.status == "1" {
                            print("OTP Verification Successful")
                            print("Message: \(otpVerificationResponse.message ?? "No Value")")
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: otpVerificationResponse.message ?? "Please check Otp Provided")
                                self.delegate?.otpVerified(otp_type: self.otp_data.otp_type)
                                
                            }
                        } else {
                            print("OTP Verification Failed")
                            print("Message: \(otpVerificationResponse.error ?? "Error")")
                            DispatchQueue.main.async {
                                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: otpVerificationResponse.error ?? "Please check Otp Provided")
                                self.otp_text.clearOTP()
                               // self.delegate?.otpVerified(otp_type: self.otp_data.otp_type)
                            }
                            

                        }
                    } catch {
                        print("Error decoding API response: \(error)")
                        DispatchQueue.main.async {
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: error.localizedDescription )
                            self.otp_text.clearOTP()
                            //self.delegate?.otpVerified(otp_type: "NA")
                        }

                    }
                    // You can handle the response data here
                }
            }
            // Start the URLSession task
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
            IJProgressView.shared.hideProgressView()

        }
    }
    
    
}
