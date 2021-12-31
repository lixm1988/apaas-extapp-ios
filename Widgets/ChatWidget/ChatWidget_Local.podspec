Pod::Spec.new do |spec|
  spec.name         = "ChatWidget"
  spec.version      = "2.0.0"
  spec.summary      = "CloudClass Widget"
  spec.description  = "CloudClass Chat Widget"
  spec.homepage     = "https://docs.agora.io/en/agora-class/landing-page?platform=iOS"
  spec.license      = { "type" => "Copyright", "text" => "Copyright 2020 agora.io. All rights reserved." }
  spec.author       = { "Agora Lab" => "developer@agora.io" }
  spec.module_name  = "ChatWidget"

  spec.ios.deployment_target = "10.0"

  spec.source              = { :git => "ssh://git@git.agoralab.co/aduc/open-apaas-extapp-ios.git", :tag => 'ChatWidget_v' + "#{spec.version.to_s}" }
  spec.resources           = "ChatWidget/ChatWidget.bundle"
  spec.source_files        = "ChatWidget/**/*.{h,m,strings}"
  spec.public_header_files = [
    "ChatWidget/Main/ChatWidget.h"
  ]
    
  spec.dependency "HyphenateChat"
  spec.dependency "AgoraWidget"
  spec.dependency "SDWebImage"
  spec.dependency "Masonry"
  spec.dependency "WHToast", "0.0.7"
  spec.frameworks = "UIKit"
  spec.libraries  = "stdc++"
    
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES','EXCLUDED_ARCHS[sdk=iphonesimulator*]'=>'i386,arm64','VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
