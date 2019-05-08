#
# Be sure to run `pod lib lint XTRingChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XTRingChart'
  s.version          = '0.1.2'
  s.summary          = 'XTRingChart.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '圆环统计表格 RingChart'

  s.homepage         = 'https://github.com/yuyedaidao/YQRingChart'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wyqpadding@gmail.com' => 'wyqpadding@gmail.com' }
  s.source           = { :git => 'https://github.com/yuyedaidao/YQRingChart.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XTRingChart/Classes/**/*'
  s.swift_version = '4.2'
#s.resource_bundles = {
#    'XTRingChart' => ['XTRingChart/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'Moya/RxSwift', '~> 12.0'
  # s.dependency 'SnapKit', '~> 4.0.0'
  # s.dependency 'RxCoreData', '~> 0.5.1'
  # s.dependency 'RxDataSources', '~> 3.0'
end
