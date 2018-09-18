
Pod::Spec.new do |s|
    s.name         = 'SGPagingViewSwift'
    s.version      = '0.0.1'
    s.summary      = 'A powerful and easy to use segment control'
    s.license      = 'MIT'
    s.homepage     = 'https://github.com/kingsic/SGPagingView-Swift'
    s.authors      = {'kingsic' => 'kingsic@126.com'}
    s.source       = {:git => 'https://github.com/kingsic/SGPagingView-Swift.git', :tag => s.version}
    s.source_files = 'SGPagingViewSwift/*.swift'

    s.platform     = :ios
    s.ios.deployment_target = '8.0'
    s.swift_version = '4.0.0'
    s.requires_arc = true
end
