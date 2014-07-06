default['mysql']['server_root_password'] = 'root'
default['mysql']['data_dir'] = '/data'

case node[:platform] 
when "debian","ubuntu"
	default['mysql']['version'] = '5.5'
	default['apache']['user'] = "www-data"
    default['apache']['group'] = "www-data"
when "centos","redhat"
	default['mysql']['version'] = '5.1'
	default['apache']['user'] = "apache"
    default['apache']['group'] = "apache"
end
