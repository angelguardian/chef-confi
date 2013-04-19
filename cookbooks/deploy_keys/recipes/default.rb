
package "curl" do
  action :install
end

ruby_block "run create deploy key" do
  block do
    key_file = "/home/#{node[:deploy_keys][:user]}/.ssh/id_dsa.pub" 
    key = `cat #{key_file} | tr -d '\n'`
    title = node[:deploy_keys][:box_name]

    cmd = "curl -d '{\"title\": \"#{title}\", \"key\": \"#{key}\"}' -H 'Authorization: token #{node[:deploy_keys][:github_token]}' https://api.github.com/repos/#{node[:deploy_keys][:github_user]}/#{node[:deploy_keys][:github_repo]}/keys"

    Chef::Log.info(cmd)

    system cmd

  end
end
