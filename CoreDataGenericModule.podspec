Pod::Spec.new do |s|
	s.name = 'CoreDataGenericModule'
	s.version = '1.0.6'
	s.summary = 'Core Data generic module for persist encrypted object'
	s.authors = { "Arturo Carretero Calvo" => "10163049+ArtCC@users.noreply.github.com" }
	s.social_media_url = 'https://twitter.com/_artcc_'
	s.license = { :type => "MIT", :file => "LICENSE" }
  s.source = { :git => "https://github.com/ArtCC/CoreDataGenericModule.git", :tag => "#{s.version.to_s}" }
	s.description = 'Core Data generic module for persist encrypted object'
	s.homepage = 'https://github.com/ArtCC/CoreDataGenericModule'
  s.source_files = 'Classes/**/*.{swift}'
  s.resources = 'Classes/Model/*.xcdatamodeld'
  s.platform = :ios
  s.dependency 'RNCryptor'
end
