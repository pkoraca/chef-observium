#
# Cookbook Name:: observium
# Recipe:: default
#

require 'rubygems'

include_recipe 'apache2'
include_recipe 'mysql::server'

if platform?('centos', 'redhat')
  include_recipe 'yum'
  include_recipe 'yum-epel'
  include_recipe 'yum-repoforge'
end

# http://www.cryptocracy.com/blog/2014/04/29/five-things-i-hate-about-chef/
# require mysql fails due to https://sethvargo.com/using-gems-with-chef/

# Run first because of dependencies for mysql gem
if platform?("ubuntu", "debian")
  %w{build-essential libmysqlclient-dev libapache2-mod-php5 php5-cli php5-mysql php5-gd php5-snmp php-pear snmp graphviz php5-mcrypt php5-json subversion mysql-client rrdtool fping imagemagick whois mtr-tiny nmap ipmitool python-mysqldb}.each do |p|
    package p do
      action :nothing
    end.run_action(:install)
end

else
  %w{wget ruby-devel gcc rubygems php mysql mysql-devel php-mysql php-gd php-snmp php-pear net-snmp net-snmp-utils graphviz subversion rrdtool ImageMagick jwhois nmap ipmitool MySQL-python}.each do |p|
    package p do
      action :nothing
    end.run_action(:install)
  end
end

r = chef_gem "mysql" do
  action :nothing
end
r.run_action(:install)

Gem.clear_paths

require 'mysql'

if platform?('centos', 'redhat')
 # since include_recipe yum-epel runs later than .run_action()
  %w{php-mcrypt fping collectd-rrdtool}.each do |pkg|
    package pkg
  end
end

# Ruby code in the ruby_block resource is evaluated with other resources during convergence, whereas Ruby code outside of a ruby_block resource is evaluated before other resources, as the recipe is compiled.
ruby_block "create_observium_db" do
  block do
    create_observium_db
  end
  action :create 
end

ark 'observium' do
  url 'http://www.observium.org/observium-community-latest.tar.gz'
  prefix_root '/opt'
  path '/opt'
  home_dir '/opt/observium'
  owner node['apache']['user']
end

template '/opt/observium/config.php' do
  source 'config.php.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0766
end

directory '/opt/observium/rrd' do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00755
  action :create
end

directory '/opt/observium/logs' do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00755
  action :create
end

# Setup the MySQL database and insert the default schema
execute 'php includes/update/update.php' do
  cwd '/opt/observium'
  # not_if ''
end

# create admin
execute './adduser.php admin admin 10' do
  cwd '/opt/observium'
end

# Initial discovery
execute './discovery.php -h all' do
  cwd '/opt/observium'
end

# Initial polling
execute './poller.php -h all' do
  cwd '/opt/observium'
end

web_app 'observium' do
  server_name 'observium.infobip-test.local'
  server_aliases ['localhost', 'observium-dev']
  docroot '/opt/observium/html/'
  allow_override 'all'
end

cron_d 'discovery-all' do
  minute  00
  command '/opt/observium/discovery.php -h all >> /dev/null 2>&1'
  user    'root'
end

cron_d 'discovery-new' do
  minute  00
  command '/opt/observium/discovery.php -h new >> /dev/null 2>&1'
  user    'root'
end

cron_d 'poller-wrapper' do
  minute  00
  command '/opt/observium/poller-wrapper.py 1 >> /dev/null 2>&1'
  user    'root'
end
