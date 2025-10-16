# Uncomment the next line to define a global platform for your project
platform :ios, '14.3'

target 'SDET Demo App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for My Demo App

  pod 'TestFairy', '1.30.1'
  pod 'FormTextField', '3.1.0'
  pod 'EasyTipView', '2.1.0'

end

# Этот скрипт исправит предупреждения о версии deployment target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.3'
    end
  end
end
