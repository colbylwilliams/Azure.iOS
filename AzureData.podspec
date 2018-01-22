#
# Be sure to run `pod lib lint AzureData.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AzureData'
  s.version          = '0.5.6'
  s.summary          = 'iOS client for Microsoft\'s Azure Cosmos DB DocumentDB written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  AzureData is an iOS, watchOS, macOS, tvOS client for Microsoft\'s Azure Cosmos DB DocumentDB written in Swift

  It originally created as part of **[Azure.Mobile](https://aka.ms/mobile)** — a framework for rapidly creating iOS and android apps with modern, highly-scalable backends on Azure — built with two simple objectives:

  1. Enable developers to create, configure, deploy all necessary backend services fast — ideally under 10 minutes with only a few clicks
  2. Provide native iOS and android SDKs with delightful APIs to interact with the services
                       DESC

  s.homepage         = 'https://aka.ms/azureios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Colby Williams'
  # s.author           = { 'Colby Williams' => 'colbylwilliams@gmail.com' }
  s.source           = { :git => 'https://github.com/colbylwilliams/Azure.iOS.git', :tag => "v#{s.version}" }
  # s.social_media_url = 'https://twitter.com/colbylwilliams'
  # s.social_media_url = 'https://www.instagram.com/colbylwilliams'

  s.ios.deployment_target = '11.1'
  # s.osx.deployment_target = '10.13'
  # s.tvos.deployment_target = '11.1'
  # s.watchos.deployment_target = '4.0'

  s.source_files = 'AzureData/Source/*.swift', 'AzureData/Source/Resources/*.swift', 'AzureData/Source/*.h', 'AzureData/Source/*.m'
  
  # s.resource_bundles = {
  #   'AzureData' => ['AzureData/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.ios.frameworks = 'Foundation', 'CommonCrypto'
  # s.osx.frameworks = 'Foundation', 'CommonCrypto'
  # s.dependency 'AFNetworking', '~> 2.3'
end
