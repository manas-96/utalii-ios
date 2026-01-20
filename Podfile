platform :ios, '15.0'

use_frameworks!

target 'Utalii' do
  pod 'SwiftyJSON', '~> 5.0'
  pod 'Alamofire', '~> 5.0'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'NBBottomSheet'
  pod 'NewPopMenu'
  pod 'SwiftMessages'
  pod 'RSSelectionMenu'
  pod 'DatePickerDialog'
  pod 'iOSDropDown'
  pod 'Cosmos'
  pod 'AEOTPTextField'

  pod 'GoogleMaps', '~> 8.0'
  pod 'GooglePlaces', '~> 8.0'

  pod 'Firebase'
  pod 'FirebaseMessaging'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      
      # Ensure the project builds for the native architecture (arm64)
      # We REMOVE the EXCLUDED_ARCHS line entirely to let Xcode handle it
      config.build_settings.delete 'EXCLUDED_ARCHS[sdk=iphonesimulator*]'
      
      # Standard setting for modern Xcode projects
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
    end
  end
end



## Uncomment the next line to define a global platform for your project
#platform :ios, '15.0'
#
#target 'Utalii' do
#  # Comment the next line if you don't want to use dynamic frameworks
#  use_frameworks!
#
#  # Pods for Utalii
#  	pod 'SwiftyJSON'  
#	pod 'Alamofire', '~> 4.9.1'
#	pod 'SDWebImage'
#	pod 'IQKeyboardManagerSwift'
#	pod 'NBBottomSheet' 
#	pod 'NewPopMenu'
#	pod 'SwiftMessages'
#	pod 'RSSelectionMenu'
#	pod 'DatePickerDialog'
#	pod 'GooglePlaces'
#	pod 'GooglePlacePicker'
#  	pod 'iOSDropDown'
# 	pod 'Cosmos'
#	pod 'Firebase/Messaging'
#	pod 'AEOTPTextField'
#
#end
#
#post_install do |installer|
#    installer.generated_projects.each do |project|
#          project.targets.each do |target|
#              target.build_configurations.each do |config|
#                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#               end
#          end
#   end
#end
#
