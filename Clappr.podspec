Pod::Spec.new do |s|
  s.name             = "Clappr"
  s.version          = "0.3.13"
  s.summary          = "An extensible media player for iOS"
  s.homepage         = "http://clappr.io"
  s.license          = 'MIT'
  s.authors          = {
    "Diego Marcon" => "dm.marcon@gmail.com",
    "Thiago Pontes" => "thiagopnts@gmail.com",
    "Gustavo Barbosa" => "gustavocsb@gmail.com",
    "Bruno Torres" => "me@brunotorr.es",
    "Fernando Pinho" => "fpinho@gmail.com"
  }

  s.source           = { :git => "https://github.com/clappr/clappr-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Resources/*.{xib,ttf,png,xcassets}'

  s.dependency 'Kingfisher', '~> 2.4'
end
