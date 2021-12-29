Pod::Spec.new do |spec|
    spec.name             = 'ChatWidget'
    spec.version          = '2.0.0'
    spec.summary          = 'CloudClass Widget'
    spec.description      = 'CloudClass Chat Widget'

    spec.module_name   = 'ChatWidget'
    spec.homepage     = 'https://docs.agora.io/en/agora-class/landing-page?platform=iOS'
    spec.license      = { "type" => "Copyright", "text" => "Copyright 2020 agora.io. All rights reserved." }
    spec.author       = { "Agora Lab" => "developer@agora.io" }
    spec.source       = { :git => "git@github.com:AgoraIO-Community/apaas-extapp-ios.git", :tag => 'ChatWidget_v' + "#{spec.version.to_s}" }
    spec.frameworks = 'UIKit'
    spec.libraries = 'stdc++'
    spec.ios.deployment_target = '9.0'
    
    spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES','EXCLUDED_ARCHS[sdk=iphonesimulator*]'=>'i386,arm64','VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
    
    spec.dependency 'Masonry'
    spec.dependency 'HyphenateChat'
    spec.dependency 'SDWebImage'
    spec.dependency 'WHToast'

    spec.resources = 'ChatWidget/ChatWidget.bundle'
    spec.source_files = 'Widgets/ChatWidget/ChatWidget/**/*.{h,m,strings}', 'ChatWidget/**/*.{h,m,strings}'
    spec.public_header_files = [
      'ChatWidget/Main/ChatWidget.h',
      'Widgets/ChatWidget/ChatWidget/Main/ChatWidget.h'
    ]

    spec.dependency "AgoraWidget", '>=2.0.1'
end
