#
# Cookbook Name:: php-box
# Recipe:: default
#
# Copyright 2013, Sergey Storchay
#

include_recipe "php"

template "#{node['php']['ext_conf_dir']}/phar.ini" do
  source "phar.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end

#install/upgrade curl
package "curl" do
  action :upgrade
end

command = "curl -s http://box-project.org/installer.php | php"

bash "download_box" do
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
    #{command}
  EOH
end

if node["php-box"]["install_globally"]
  bash "move_box" do
    cwd "#{Chef::Config[:file_cache_path]}"
    code <<-EOH
      sudo mv box.phar #{node["php-box"]["prefix"]}/bin/box
    EOH
  end
end
