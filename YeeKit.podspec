Pod::Spec.new do |s|
  s.name             = 'YijingUI'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight SwiftUI extension kit for data/state/view handling.'
  s.description      = <<-DESC
    YijingUI is a modular and elegant SwiftUI utility library focused on data handling,
    state management, and view extensions. Inspired by the philosophy of "祎境" — a realm of clarity and refinement.
  DESC

  s.homepage         = 'https://github.com/your-username/YijingUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '祎境' => 'your@email.com' }

  s.source           = { :git => 'https://github.com/your-username/YijingUI.git', :tag => s.version }

  s.swift_version    = '5.7'
  s.ios.deployment_target = '14.0'

  s.source_files     = 'Sources/YijingUI/**/*.{swift}'
  s.module_name      = 'YijingUI'
  s.requires_arc     = true
end
