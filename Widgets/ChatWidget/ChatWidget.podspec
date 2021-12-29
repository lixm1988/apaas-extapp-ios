Pod::Spec.new do |s|
    s.name             = 'ChatWidget'
    s.version          = '2.0.0'
    s.summary          = 'CloudClass Chat Widget'
    s.description      = <<-DESC
        ‘灵动课堂聊天插件.’
    DESC
    s.homepage     = 'https://docs.agora.io/en/agora-class/landing-page?platform=iOS'
    s.license      = { "type" => "Copyright", "text" => "Copyright 2020 agora.io. All rights reserved." }
    s.author       = { "Agora Lab" => "developer@agora.io" }
    s.source           = { :git => "git@github.com:AgoraIO-Community/apaas-extapp-ios.git", :tag => 'ChatWidget_v' + "#{spec.version.to_s}" }
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '9.0'
    
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES','EXCLUDED_ARCHS[sdk=iphonesimulator*]'=>'i386,arm64','VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
    
    s.dependency 'Masonry'
    s.dependency 'HyphenateChat'
    s.dependency 'SDWebImage'
    s.dependency 'WHToast'

    s.resources = 'ChatWidget/ChatWidget.bundle'
    s.source_files = 'Widgets/ChatWidget/ChatWidget/**/*.{h,m,strings}', 'ChatWidget/**/*.{h,m,strings}'
    s.public_header_files = [
      'ChatWidget/Main/ChatWidget.h',
      'Widgets/ChatWidget/ChatWidget/Main/ChatWidget.h'
    ]

    s.dependency "AgoraWidget", '>=2.0.1'
end
