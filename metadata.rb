name 'observium'
maintainer 'Petar Koraca'
maintainer_email 'pkoraca@gmail.om'
license 'Apache'
description 'Installs/Configures Observium'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.2'

%w(yum yum-epel yum-repoforge ark cron apache2 mysql database).each do |pkg|
  depends pkg
end

%w(redhat centos ubuntu debian).each do |os|
  supports os
end
