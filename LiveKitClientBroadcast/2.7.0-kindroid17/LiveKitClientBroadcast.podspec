Pod::Spec.new do |spec|
  spec.name = "LiveKitClientBroadcast"
  spec.version = "2.7.0-kindroid17"
  spec.summary = "Broadcast extension variant of the LiveKit Swift Client SDK."
  spec.homepage = "https://github.com/livekit/client-sdk-swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.author = "LiveKit"

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"

  spec.swift_versions = ["5.9"]
  spec.source = { :git => "https://github.com/KindroidAI/client-sdk-swift.git", :tag => spec.version.to_s }

  xcode_output = `xcodebuild -version`.strip
  major_version = xcode_output =~ /Xcode\s+(\d+)/ ? $1.to_i : 15

  swift_flags = []
  swift_flags << "-enable-experimental-feature AccessLevelOnImport" if major_version >= 15
  swift_flags << "-DLK_BROADCAST_EXTENSION"

  spec.module_name = "LiveKitClientBroadcast"
  spec.static_framework = false

  spec.source_files = "Sources/**/*"
  spec.public_header_files = "Sources/LKObjCHelpers/include/**/*.h"
  spec.header_mappings_dir = "Sources/LKObjCHelpers/include"
  spec.resource_bundles = { "PrivacyBroadcast" => ["Sources/LiveKit/PrivacyInfo.xcprivacy"] }

  spec.dependency "LiveKitWebRTC", "= 137.7151.03"
  spec.dependency "SwiftProtobuf"
  spec.dependency "Logging", "= 1.5.4"
  spec.dependency "DequeModule", "= 1.1.4"
  spec.dependency "OrderedCollections", "= 1.1.4"

  spec.pod_target_xcconfig = {
    "APPLICATION_EXTENSION_API_ONLY" => "YES",
    "OTHER_SWIFT_FLAGS" => swift_flags.join(" "),
    "HEADER_SEARCH_PATHS" => '$(inherited) "${PODS_TARGET_SRCROOT}/Sources/LKObjCHelpers/include"',
    "PRODUCT_NAME" => "LiveKitClientBroadcast",
    "PRODUCT_MODULE_NAME" => "LiveKitClientBroadcast"
  }
end
