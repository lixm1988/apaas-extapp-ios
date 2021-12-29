Pod::Spec.new do |spec|
  spec.name         = "AgoraExtApps"
  spec.version      = '2.0.0'
  spec.summary      = "Agora Extension Apps."
  spec.description  = "Agora Native Extension Apps."
  
  spec.homepage     = "https://docs.agora.io/en/agora-class/landing-page?platform=iOS"
  spec.license      = { "type" => "Copyright", "text" => "Copyright 2020 agora.io. All rights reserved." }
  spec.author       = { "Agora Lab" => "developer@agora.io" }
  spec.source       = { :git => "git@github.com:AgoraIO-Community/apaas-extapp-ios.git", :tag => 'AgoraExtApps_v' + "#{spec.version.to_s}"
  spec.ios.deployment_target = "10.0"

  spec.module_name   = 'AgoraExtApps'
  spec.xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4']
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
  spec.user_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
  spec.module_map = 'AgoraExtApps.modulemap'

  spec.source_files  = "ExtApps/Classes/**/*.{h,m,swift}"
  
  spec.dependency "Armin"
  spec.dependency "Masonry"
  spec.dependency "AgoraLog"
  spec.dependency "AgoraExtApp"
  spec.dependency "SwifterSwift"
  spec.dependency "AgoraUIBaseViews"
  spec.dependency "AgoraUIEduBaseViews"

  spec.subspec 'Resources' do |ss|
      ss.resource_bundles = {
        'AgoraExtApps' => ['ExtApps/Assets/**/*.{xcassets,strings,gif,mp3}']
      }
  end
end
