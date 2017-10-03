platform :ios, '9.0'

use_frameworks!

target 'JTAppleCalendarBonk' do
  
  pod 'JTAppleCalendar'
  pod 'EasyPeasy'

end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '3.2'
end
end
end