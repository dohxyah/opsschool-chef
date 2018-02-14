apt_update 'update'

package 'nginx' do
  action :install
end

directory node['site']['path'] do
  owner node['site']['user']
  group node['site']['user']
  mode '0755'
  action :create
end

cookbook_file "#{node['site']['path']}/index.html" do
  source 'index.html'
  owner node['site']['user']
  group node['site']['user']
  mode '0755'
end

remote_file "#{node['site']['path']}/logo.png" do
  source node['logo']['url']
  owner node['site']['user']
  group node['site']['user']
  mode '0755'
  action :create
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

service 'nginx' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/nginx/sites-available/logo' do
  source 'logo.nginx-conf.erb'
  owner node['site']['user']
  group node['site']['user']
  mode '0755'
  notifies :reload, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/logo' do
  to '/etc/nginx/sites-available/logo'
end
