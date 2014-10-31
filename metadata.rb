name             'etherpad-lite'
maintainer       'Boye Holden & OpenWatch FPC'
maintainer_email 'boye.holden@hist.no & chris@openwatch.net'
license          'Apache 2.0'
description      'Installs etherpad-lite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends 'nodejs', '>= 2.0'
depends 'lamp-stack'
