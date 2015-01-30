name             'etherpad-lite'
maintainer       'Boye Holden'
maintainer_email 'boye.holden@hist.no'
license          'Apache 2.0'
description      'Installs etherpad-lite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

recipe 'etherpad-lite::default', 'Installs package'
recipe 'etherpad-lite::etherpad', 'Installs Etherpad-lite'
recipe 'etherpad-lite::apache', 'Installs Apache2 as proxy'
recipe 'etherpad-lite::mysql', 'Installs MySQL database'
recipe 'etherpad-lite::nodejs', 'Installs NodeJS'

%w(ubuntu debian).each do |os|
  supports os
end

%w(apache2 mysql database nodejs logrotate).each do |pkg|
  depends pkg
end