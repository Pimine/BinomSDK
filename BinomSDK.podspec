Pod::Spec.new do |s|
  s.name            = 'BinomSDK'
  s.version         = '0.1.0'
  s.summary         = 'SDK for Binom'

  s.description     = 'Custom SDK for Binom CPA Tracker'

  s.homepage        = 'https://github.com/Pimine/BinomSDK'
  s.license         = { :type => 'Custom', :file => 'LICENSE' }
  s.authors         = { 'Den Andreychuk' => 'denis.andrei4uk@yandex.ua' }

  s.source          = {
    :git => 'https://github.com/Pimine/BinomSDK.git',
    :tag => s.version.to_s
  }
  
  s.ios.deployment_target = '12.0'

  s.swift_version   = ['5.1', '5.2']
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/**/*.swift'
    ss.dependency 'Moya'
  end

end
