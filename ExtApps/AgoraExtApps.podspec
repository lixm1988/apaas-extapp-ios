Pod::Spec.new do |spec|
  spec.name         = "AgoraExtApps"
  spec.version      = "1.0.0"
  spec.summary      = "Agora Extension Apps."
  spec.description  = "Agora Native Extension Apps."
  
  spec.homepage     = "https://docs.agora.io/en/agora-class/landing-page?platform=iOS"
  spec.license      = { "type" => "Copyright", "text" => "Copyright 2020 agora.io. All rights reserved." }
  spec.author       = { "Lyy" => "liuyuanyuan02@agora.io" }
  spec.source       = { :git => "ssh://git@git.agoralab.co/aduc/open-apaas-extapp-ios.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = "10.0"

  spec.module_name   = 'AgoraExtApps'
  spec.xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4']
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
  spec.user_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
  spec.module_map = 'AgoraExtApps.modulemap'

  spec.source_files  = "ExtApps/**/*.{h,m,swift}","ExtApps/*.{h,m,swift}","*.{h,m,swift}", "AnswerSheetExtApp/**/*.{h,m,swift}", "CountDownExtApp/*.{h,m,swift}"
  
  spec.dependency "Armin"
  spec.dependency "Masonry"
  spec.dependency "AgoraLog"
  spec.dependency "AgoraExtApp"
  spec.dependency "SwifterSwift"
  spec.dependency "AgoraUIBaseViews"
  spec.dependency "AgoraUIEduBaseViews"

  spec.subspec 'Resources' do |ss|
      ss.resource_bundles = {
        'AgoraExtApps' => ["AgoraResources/*/*.{strings}", 
                           "*.xcassets",
                           "ExtApps/AgoraResources/*/*.{strings}",
                           "ExtApps/*.xcassets"]
      }
  end
end
