platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def other
  pod 'Factory'
end

def ui
  pod 'MBProgressHUD'
end

def networking
  pod 'Loggie'
  pod 'Japx/RxAlamofire'
  pod 'OHHTTPStubs/Swift'
end

def database
  pod 'RealmSwift'
end

def reactive
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'CombineExt'
  pod 'CombineCocoa'
end

def localization
  pod 'SwiftI18n/I18n+Case'
end

def testing
  pod 'RxBlocking'
  pod 'RxTest'
  pod 'Nimble'
  pod 'Quick'
  pod 'RxNimble'
end

def shared
  networking
  database
  reactive
  localization
  ui
  other
end

target 'Catalog' do

  shared

  target "Tests" do
    inherit! :search_paths
    testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
