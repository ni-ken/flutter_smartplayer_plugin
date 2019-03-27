#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'smartplayer_native_view'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.frameworks = ["Accelerate", "AssetsLibrary","AudioToolbox","AVFoundation","CoreMedia","Foundation","OpenGLES","GLKit","VideoToolbox","UIKit","QuartzCore"]
  s.libraries = ["bz2", "iconv", "c++","z"]
  s.preserve_paths = 'Lib/*.a'
  s.vendored_libraries = "**/*.a"
  s.ios.deployment_target = '8.0'
end

