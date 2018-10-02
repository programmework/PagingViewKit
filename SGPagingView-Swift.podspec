
Pod::Spec.new do |s|
    s.name         = 'SGPagingView-Swift'
    s.version      = '0.0.5'
    s.summary      = 'A powerful and easy to use segment control'
    s.license      = 'MIT'
    s.homepage     = 'https://github.com/kingsic/SGPagingView-Swift'
    s.authors      = {'kingsic' => 'kingsic@126.com'}
    s.source       = {:git => 'https://github.com/kingsic/SGPagingView-Swift.git', :tag => s.version}
    s.source_files = 'SGPagingView-Swift/*.swift'

    s.platform     = :ios
    s.ios.deployment_target = '9.0'
    s.swift_version = '4.2'
    s.requires_arc = true
end
