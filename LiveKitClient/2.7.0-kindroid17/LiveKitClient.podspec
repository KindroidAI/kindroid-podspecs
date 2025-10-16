Pod::Spec.new do |spec|
  spec.name = "LiveKitClient"
  spec.version = "2.7.0-kindroid17"
  spec.summary = "LiveKit Swift Client SDK. Easily build live audio or video experiences into your mobile app, game or website."
  spec.homepage = "https://github.com/livekit/client-sdk-swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.author = "LiveKit"

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"

  spec.swift_versions = ["5.9"]
  spec.source = { :git => "https://github.com/KindroidAI/client-sdk-swift.git", :tag => spec.version.to_s }

  spec.default_subspec = "Core"

  xcode_output = `xcodebuild -version`.strip
  major_version = xcode_output =~ /Xcode\s+(\d+)/ ? $1.to_i : 15

  common_swift_flags = []
  common_swift_flags << "-enable-experimental-feature AccessLevelOnImport" if major_version >= 15

  core_swift_flags = common_swift_flags.join(" ")
  broadcast_swift_flags = (common_swift_flags + ["-DLK_BROADCAST_EXTENSION"]).join(" ")

  add_common_dependencies = lambda do |subspec|
    subspec.dependency "LiveKitWebRTC", "= 137.7151.03"
    subspec.dependency "SwiftProtobuf"
    subspec.dependency "Logging", "= 1.5.4"
    subspec.dependency "DequeModule", "= 1.1.4"
    subspec.dependency "OrderedCollections", "= 1.1.4"
  end

  spec.subspec "Core" do |core|
    core.source_files = "Sources/**/*"
    core.resource_bundles = { "Privacy" => ["Sources/LiveKit/PrivacyInfo.xcprivacy"] }

    add_common_dependencies.call(core)

    unless core_swift_flags.empty?
      core.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS" => core_swift_flags }
    end
  end

  spec.subspec "Broadcast" do |broadcast|
    broadcast.source_files = "Sources/**/*"
    broadcast.resource_bundles = { "Privacy" => ["Sources/LiveKit/PrivacyInfo.xcprivacy"] }

    add_common_dependencies.call(broadcast)

    config = { "APPLICATION_EXTENSION_API_ONLY" => "YES" }
    config["OTHER_SWIFT_FLAGS"] = broadcast_swift_flags unless broadcast_swift_flags.empty?
    broadcast.pod_target_xcconfig = config
  end
end
