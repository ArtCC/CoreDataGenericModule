Pod::Spec.new do |s|
  s.name             = "CoreDataGenericModule"
  s.version          = "1.0.0"
  s.summary          = "Core Data generic module for persist encrypted object"
  s.description      = <<-DESC
                          Core Data generic module for persist encrypted object
                          DESC
  s.homepage         = "https://github.com/ArtCC/CoreDataGenericModule"
  # s.screenshots    = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Arturo Carretero Calvo" => "artccmail@gmail.com" }
  s.social_media_url = "https://twitter.com/_artcc_"
  s.platform         = :ios
  s.source           = { :git => "https://github.com/ArtCC/CoreDataGenericModule.git", :tag => s.version }
  s.source_files     = "Classes/**/*.{swift}"
  s.resources        = "*.xcdatamodeld"
  s.dependency 'RNCryptor', '~> 4.0.0-beta'
end
