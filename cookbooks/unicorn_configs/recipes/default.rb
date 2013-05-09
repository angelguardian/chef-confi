
directory "#{node[:unicorn_config][:main_log]}" do
  mode "770"
  owner "nobody"
  action :create
end

directory "#{node[:unicorn_config][:main_log]}/#{node[:unicorn_config][:app_log]}" do
  mode "770"
  owner "nobody"
  action :create
end

# run the nginx::default recipe to install nginx
include_recipe 'nginx::ohai_plugin'
# include_recipe "nginx"
service "nginx" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end


# deploy your sites configuration from the files/ driectory in your cookbook
# cookbook_file "#{node['nginx']['dir']}/sites-available/rails-app.com" do
#   source "rails-app.com"
#   owner "root"
#   group "root"
#   mode  "0644"
#   notifies :restart, resources(:service => "nginx")
# end


# enable your sites configuration using a definition from the nginx cookbook
# nginx_site "rails-app.com" do
#   enable true
# end

# ruby_block "Create config" do
#   block do
#     res = Chef::Resource::Template.new "#{node['nginx']['dir']}/sites-available/rails-app.com", run_context
#     res.source "rails-app.com"
#     res.mode "0644"
#     res.run_action :create
#     res.notifies :restart, resources(:service => "nginx")
#   end
# end

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

ruby_block "Create new group and set permission" do
  block do
    system("sudo groupadd rooties")
    system("sudo usermod -a -G rooties #{node[:unicorn_config][:user]}")
    system("sudo usermod -a -G rooties root")
    system("sudo chgrp -R rooties /var/log/rails")
    system("sudo chgrp -R rooties /var/log/rails/rails-app")
    system("sudo chgrp -R rooties /var/run")
  end
end