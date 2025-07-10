Pod::Spec.new do |s|
  s.name             = 'YeeKit'
  s.version          = '1.0.3'
  s.summary          = 'A lightweight SwiftUI extension kit for data/state/view handling.'
  s.description      = <<-DESC
    YijingUI is a modular and elegant SwiftUI utility library focused on data handling
  DESC

  s.homepage         = 'https://github.com/yijingKing/YeeKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '祎境' => '1091676312@email.com' }

  s.source           = { :git => 'https://github.com/yijingKing/YeeKit.git', :tag => s.version }

  s.swift_version    = '5.0'
  s.ios.deployment_target = '14.0'

  s.source_files     = 'Sources/**/*.{swift}'
  s.module_name      = 'YeeKit'
  s.requires_arc     = true
  
end
