desc 'Builds the release version of the native library for ios'
task :ios_release_build do
  `xcodebuild -project native/ios/NAH_B2D/NAH_B2D.xcodeproj -target NAH_B2D -configuration Release`
end

task :default => [ :ios_release_build ]
