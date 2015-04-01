Pod::Spec.new do |s|
    s.name = 'RBLib'
    s.version = '0.0.1'
    s.license = 'MIT'
    s.summary = 'RBLib'
    s.homepage = 'http://www.aipai.com/'
    s.author = { 'aipai' => 'http://www.aipai.com/' }
    s.source = { :git => './RBLib'}
    s.platform     = :ios, '7.0' #支持的平台及版本
    s.requires_arc = true  #是否使用ARC，如果指定具体文件，则具体的问题使用ARC

    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.8'

    #s.public_header_files = 'RBLib/*.h'

    #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置
    #s.source_files = 'RBLib/*.{h,m}'  

    #资源文件地址
    #s.resource_bundles = {
    #       'BZLib' => ['Pod/Assets/*.png']
    #}
    #s.public_header_files = 'Pod/Classes/**/*.h' #公开头文件地址
    #s.frameworks = 'QuartzCore', 'CFNetwork', 'CoreGraphics' #所需的framework，多个用逗号隔开
    #s.libraries = 'xml2', 'sqlite3', 'z'
    #s.dependency 'YSASIHTTPRequest', '~> 2.0.1' #依赖关系，该项目所依赖的其他库，如果有多个需要填写多个s.dependency
end



# http://blog.zephyrleaves.net/?p=712
# http://guides.cocoapods.org/syntax/podspec.html
