platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

def networking
  pod 'Alamofire'
  pod 'Loggie'
  pod 'CodableAlamofire'
  pod 'Japx/RxCodableAlamofire'
end

def reactive
  pod 'RxSwift'
  pod 'RxCocoa'
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
  reactive
  localization
end

target 'Catalog' do

  shared

  target "Tests" do
    inherit! :search_paths
    testing
  end

end
