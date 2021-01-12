#
#  Be sure to run `pod spec lint PagingViewKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "PagingViewKit"
  spec.version      = "1.1.5"
  spec.summary      = "A powerful and easy to use segment view"
  spec.homepage     = "https://github.com/kingsic/PagingViewKit"
  spec.license      = "MIT"
  spec.author       = { "kingsic" => "kingsic@126.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = {:git => "https://github.com/kingsic/PagingViewKit.git", :tag => spec.version}
  spec.source_files = "Source/*.{swift}"
  spec.requires_arc = true
  spec.swift_versions = "5.0"
  
end
