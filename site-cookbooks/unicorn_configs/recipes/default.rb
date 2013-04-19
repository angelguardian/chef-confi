
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
include_recipe "nginx"

# deploy your sites configuration from the files/ driectory in your cookbook
cookbook_file "#{node['nginx']['dir']}/sites-available/rails-app.com" do
  owner "root"
  group "root"
  mode  "0644"
end

# enable your sites configuration using a definition from the nginx cookbook
nginx_site "rails-app.com" do
  enable true
end

# ruby_block "Create config" do
#   block do
#     res = Chef::Resource::Template.new "/etc/nginx/sites-available/#{node[:unicorn_config][:app_log]}.conf", run_context
#     res.source "nginx"
#     res.mode "0644"
#     res.run_action :create
#   end
# end



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