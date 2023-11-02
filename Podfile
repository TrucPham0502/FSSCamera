# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'FSSCamera' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FSSCamera
  pod 'RxSwift', '~> 6.5.0'
  pod 'RxCocoa', '~> 6.5.0'
  pod 'Cleanse', '~> 4.2.6'
  pod 'R.swift', '~> 7.3.2'
  pod 'IQKeyboardManagerSwift', '~> 6.5.12'
  pod 'Localize', '~> 2.3.0'
  pod 'RxAlamofire', '~> 6.1.1'
  pod 'MBProgressHUD', '~> 1.2.0'
  
  
  target 'FSSCameraTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FSSCameraUITests' do
    # Pods for testing
  end

end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end
