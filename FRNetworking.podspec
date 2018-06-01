Pod::Spec.new do |s|
  s.name         = "FRNetworking"
  s.version      = "1.0.0"
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = '7.0'
  s.summary      = "Secondary packaging library for AFN"
  s.homepage     = "https://github.com/fanrongQu/FRNetworking"
  s.license      = {:type => 'MIT', :file => "LICENSE"}
  s.author       = {"FR" => "1366225686@qq.com"}
  s.source       = {:git => "https://github.com/fanrongQu/FRNetworking.git", :tag => s.version }
  s.source_files  = "FRNetworking/*.{h,m}"
  s.requires_arc = true

  s.framework = "CFNetwork"
  s.dependency "AFNetworking", "~> 3.0"
  s.dependency 'YYCache', '~> 1.0.4'
  
end
