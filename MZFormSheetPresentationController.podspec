Pod::Spec.new do |s|
  s.name     = 'MZFormSheetPresentationController'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'MZFormSheetPresentationController provides an alternative to the native iOS UIModalPresentationFormSheet'
  s.homepage = 'https://github.com/m1entus/MZFormSheetPresentationController'
  s.authors  = 'Michał Zaborowski'
  s.source   = { :git => 'https://github.com/m1entus/MZFormSheetPresentationController.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.dependency 'MZAppearance'

  sp.source_files = 'MZFormSheetPresentationController/**/*.{h,m}'

  s.platform = :ios, '8.0'
  s.frameworks = 'QuartzCore'
end
