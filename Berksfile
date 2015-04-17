source 'https://api.berkshelf.com'

metadata

cookbook 'mysql', '~> 5'
cookbook 'apache2'
cookbook 'cron'

group :integration do
  cookbook 'yum'
  cookbook 'yum-epel'
  cookbook 'yum-repoforge'
  cookbook 'apt'
end
