#
# Be sure to run `pod lib lint DMLSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DMLSelector"
  s.version          = "1.0.2"
  s.summary          = "A drop down style selector."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  DMLSelector is a drop down style selector which support select in single, double table and collection view.

  DESC

  s.homepage         = "https://github.com/DamianSheldon/DMLSelector"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Meiliang Dong" => "dongmeilianghy@sina.com" }
  s.source           = { :git => "https://github.com/DamianSheldon/DMLSelector.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DMLSelector/Classes/**/*'
  
  s.resource_bundles = {
    'DMLSelector' => ['DMLSelector/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
