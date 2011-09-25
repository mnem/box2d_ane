desc 'Ensures the build directory exists'
task :ensure_build_directory do
	`mkdir -p build`
end

desc 'Cleans the build directory by killing it'
task :clean do
	`rm -Rf build`
end

desc 'Builds the release version of the native library for ios'
task :compile_ios_native_library do
  `xcodebuild -project native/ios/NAH_B2D/NaHBox2D.xcodeproj -target NaHBox2D -configuration Release`
end

desc 'Builds and copies the release version of the native library for ios to the build directory'
task :prepare_ios_native_library => [:ensure_build_directory, :compile_ios_native_library] do
	`cp native/ios/NAH_B2D/build/Release-iphoneos/libNaHBox2D.a build/`
end

desc 'Builds the ActionScript API for the extension'
task :compile_actionscript_api do
	`compc +configname=air -load-config+=ane/box2d_ane.config -output build/NaHBox2DAPI.swc`
end

desc 'Nicks the library.swf from it.'
task :prepare_actionscript_api => [:ensure_build_directory, :compile_actionscript_api]  do
	`unzip -o build/NaHBox2DAPI.swc library.swf -d build`
end

desc 'Packages the extension'
task :package_extension => [:ensure_build_directory, :prepare_actionscript_api, :prepare_ios_native_library] do
	`cd build;adt -package -target ane NaHBox2D.ane ../ane/extension.xml -swc NaHBox2DAPI.swc -platform iPhone-ARM library.swf libNaHBox2D.a`
end

task :default => [ :package_extension ]
