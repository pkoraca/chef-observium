name             'observium'
maintainer       'Petar Koraca'
maintainer_email 'pkoraca@gmail.om'
license          'Apache'
description      'Installs/Configures Observium'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ark cron apache2 mysql yum yum-epel yum-repoforge}.each do |pkg|
  depends pkg
end

%w{redhat centos}.each do |os|
  supports os
end