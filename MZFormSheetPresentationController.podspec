Pod::Spec.new do |s|
  s.name     = 'MZFormSheetPresentationController'
  s.version  = '2.4.2'
  s.license  = 'MIT'
  s.summary  = 'MZFormSheetPresentationController provides an alternative to the native iOS UIModalPresentationFormSheet'
  s.homepage = 'https://github.com/m1entus/MZFormSheetPresentationController'
  s.authors  = 'Michał Zaborowski'
  s.source   = { :git => 'https://github.com/m1entus/MZFormSheetPresentationController.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.dependency 'MZAppearance'

  s.source_files = 'MZFormSheetPresentationController/*.{h,m}'

  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"

  s.frameworks = 'QuartzCore'
end
