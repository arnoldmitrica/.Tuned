
target 'bucovat' do
  use_frameworks!

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Analytics'
pod 'Firebase/Database'
pod 'SideMenu'
pod 'BSImagePicker', '~> 3.1'
pod 'MaterialComponents/TextControls+FilledTextAreasTheming'
pod 'MaterialComponents/TextControls+FilledTextFieldsTheming'
pod 'MaterialComponents/TextControls+OutlinedTextAreasTheming'
pod 'MaterialComponents/TextControls+OutlinedTextFieldsTheming'
pod 'MaterialComponents/Buttons', :inhibit_warnings => true
pod 'Gifu'
pod 'FirebaseUI/Storage'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  end
 end
end