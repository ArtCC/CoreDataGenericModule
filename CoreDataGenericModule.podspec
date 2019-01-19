Pod::Spec.new do |s|
  s.name             = "CoreDataGenericModule"
  s.version          = "1.0.5"
  s.summary          = "Core Data generic module for persist encrypted object"
  s.description      = <<-DESC
                          Core Data generic module for persist encrypted object
                          DESC
  s.homepage         = "https://github.com/ArtCC/CoreDataGenericModule"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Arturo Carretero Calvo" => "10163049+ArtCC@users.noreply.github.com" }
  s.social_media_url = "https://twitter.com/_artcc_"
  s.platform         = :ios
  s.source           = { :git => "https://github.com/ArtCC/CoreDataGenericModule.git", :branch => "master", :tag => s.version.to_s }
  s.source_files     = "Classes/**/*.{swift}"
  s.resources        = "Classes/Model/*.xcdatamodeld"
  s.dependency 'RNCryptor'
end
