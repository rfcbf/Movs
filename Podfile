# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Movs' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Movs
  pod 'Alamofire', '~> 5.1'
  pod 'SwiftyJSON'
  pod 'SDWebImage'
  pod 'DeviceKit'
#  pod 'UIImageColors'
  pod 'TagListView'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
