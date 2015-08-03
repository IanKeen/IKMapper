Pod::Spec.new do |spec|
  spec.name         = 'IKMapper'
  spec.version      = '0.0.2'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/iankeen/'
  spec.authors      = { 'Ian Keen' => 'iankeen82@gmail.com' }
  spec.summary      = 'Automatic NSObject <-> NSDictionary handling.'
  spec.source       = { :git => 'https://github.com/iankeen/ikmapper.git', :tag => spec.version.to_s }

  spec.source_files = 'IKMapper/**/**.{h,m}'
  
  spec.requires_arc = true
  spec.platform     = :ios
  spec.ios.deployment_target = "7.0"
  
  spec.dependency 'IKCore', '~> 1.0'
end
