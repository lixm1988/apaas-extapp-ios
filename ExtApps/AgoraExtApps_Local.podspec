Pod::Spec.new do |spec|
  spec.name         = "AgoraExtApps"
  spec.version      = "2.0.0"
  spec.summary      = "Agora Extension Apps."
  spec.description  = "Agora Native Extension Apps."
  spec.homepage     = "https://docs.agora.io/en/agora-class/landing-page?platform=iOS"
  spec.license      = { "type" => "Copyright", "text" => "Copyright 2020 agora.io. All rights reserved." }
  spec.author       = { "Agora Lab" => "developer@agora.io" }
  spec.module_name  = 'AgoraExtApps'

  spec.ios.deployment_target = "10.0"
  spec.swift_versions        = ["5.0", "5.1", "5.2", "5.3", "5.4"]

  spec.source        = { :git => "ssh://git@git.agoralab.co/aduc/open-apaas-extapp-ios.git", :tag => 'AgoraExtApps_v' + "#{spec.version.to_s}" }
  spec.source_files  = "**/*.{h,m,swift}"
  spec.module_map    = "AgoraExtApps.modulemap"
  
  spec.dependency "AgoraUIEduBaseViews"
  spec.dependency "AgoraUIBaseViews"
  spec.dependency "SwifterSwift"
  spec.dependency "AgoraExtApp"
  spec.dependency "AgoraLog"
  spec.dependency "Masonry"
  spec.dependency "Armin"
  
  spec.pod_target_xcconfig  = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64", "DEFINES_MODULE" => "YES" }
  spec.user_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64", "DEFINES_MODULE" => "YES" }
  spec.pod_target_xcconfig  = { "VALID_ARCHS" => "arm64 armv7 x86_64" }
  spec.user_target_xcconfig = { "VALID_ARCHS" => "arm64 armv7 x86_64" } 
  spec.xcconfig             = { "BUILD_LIBRARY_FOR_DISTRIBUTION" => "YES" }
  
  spec.subspec "Resources" do |ss|
      ss.resource_bundles = {
        "AgoraExtApps" => ["Assets/**/*.{xcassets,strings,gif,mp3}"]
      }
  end
end
