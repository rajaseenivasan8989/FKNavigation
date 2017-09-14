Pod::Spec.new do |s|
s.name             = 'FKNavigation'
s.version          = '0.1.2'
s.summary          = 'By far the most fantastic view I have seen in my entire life. No joke.'

s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
DESC

s.homepage         = 'https://github.com/rajaseenivasan8989/FKNavigation.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Raja Seenivasan' => 'rajaseenivasan1@gmail.com' }
s.source           = { :git => 'https://github.com/rajaseenivasan8989/FKNavigation.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'FKNavigation/*'

end
