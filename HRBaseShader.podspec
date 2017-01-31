#
#  Be sure to run `pod spec lint HRBaseShader.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.ios.deployment_target = '8.0'
  s.name         = "HRBaseShader"
  s.version      = "0.5"
  s.summary      = "HRBaseShader share for opengles 3 shader "
  s.description  = "HRBaseShader will help linking uniform and loading and runing shader"
  s.license      = "MIT"
  s.author             = { "shsanek" => "shipin@sibers.com" }
  s.source       = { :git => "https://github.com/shsanek/HRBaseShader.git", :tag => "0.5" }
  s.source_files  = "HRBaseShader", "HRBaseShader/**/*.{h,m}"
  s.public_header_files = "HRBaseShader/**/*.h"
  s.homepage = "https://github.com/shsanek/HRBaseShader";
  s.dependency 'HRSubclasses'
end
