
Pod::Spec.new do |s|
  s.name             = 'ISHHoverBar'
  s.version          = '1.0.2'
  s.summary          = 'A vertical or horizontal toolbar that is designed to hover (float) over your content as seen in the iOS 10 Maps app'
  s.description      = <<-DESC
A floating UIToolBar replacement supporting vertical and horizontal orientation. It is designed to hover over your content and plays nicely with auto layout.

The content of the bar is set using UIBarButtonItems just as you would configure a UIToolBar. The bar is backed by a UIVisualEffectsView allowing you to select from several styles. You can customize most aspects of the view via Interface Builder.
DESC
  s.homepage         = 'https://github.com/iosphere/ISHHoverBar'
  s.screenshots      = 'https://github.com/iosphere/ISHHoverBar/raw/master/screenshot_vertical.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felix Lamouroux' => 'felix@iosphere.de' }
  s.source           = { :git => 'https://github.com/iosphere/ISHHoverBar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/iosphere'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ISHHoverBar/*.{h,m}'
  s.frameworks   = 'UIKit'
end
