#
# Cookbook Name:: etherpad-lite
# Recipe:: etherpad
#
# Copyright 2014, HiST AITeL
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

%w{gzip git-core curl python libssl-dev pkg-config build-essential}.each do |p|
  package p
end

user = node['etherpad-lite']['service_user']
user_id = node['etherpad-lite']['service_uid']
group_id = node['etherpad-lite']['service_gid']
user_home = node['etherpad-lite']['service_user_home']
project_path = "#{user_home}/etherpad-lite"

group 'etherpad' do
  gid node['etherpad-lite']['etherpad']['gid']
end

user 'etherpad' do
  uid node['etherpad-lite']['etherpad']['uid']
  gid node['etherpad-lite']['etherpad']['gid']
  home node['etherpad-lite']['etherpad']['install_dir']
  system true
  comment 'Service user for Etherpad'
end

git node['etherpad-lite']['etherpad']['install_dir'] do
  repository node['etherpad-lite']['etherpad']['git_repo']
  user 'etherpad'
  revision node['etherpad-lite']['etherpad']['revision']
  action :sync
  notifies :create, 'directory[etherpad-install-dir]'
  notifies :restart, 'service[etherpad]'
end

directory 'etherpad-install-dir' do
  path node['etherpad-lite']['etherpad']['install_dir']
  owner 'etherpad'
  group 'etherpad'
  mode 00640
end

template "#{node['etherpad-lite']['etherpad']['install_dir']}/settings.json" do
  owner 'etherpad'
  group 'etherpad'
  variables(
    :etherpad => node['etherpad-lite']['etherpad'],
    :mysql => node['etherpad-lite']['mysql']
  )
  notifies :restart, 'service[etherpad]'
end

unless node['etherpad-lite']['etherpad']['api_key']
  node.set['etherpad-lite']['etherpad']['api_key'] = ([nil]*24).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join
end
template "#{node['etherpad-lite']['etherpad']['install_dir']}/APIKEY.txt" do
  owner 'etherpad'
  group 'etherpad'
  mode 00640
  variables :api_key => node['etherpad-lite']['etherpad']['api_key']
end

execute 'etherpad-installdeps' do
  command './bin/installDeps.sh > /dev/null'
  cwd node['etherpad-lite']['etherpad']['install_dir']
  user 'root'
end

directory "#{node['etherpad-lite']['etherpad']['install_dir']}/node_modules" do
  owner 'etherpad'
  group 'etherpad'
  mode 00770
  recursive true
end

node['etherpad-lite']['etherpad']['plugins'].each do |plugin|
  nodejs_npm "ep_#{plugin}" do
    path node['etherpad-lite']['etherpad']['install_dir']
    user 'etherpad'
    group 'etherpad'
    action :install
    notifies :restart, 'service[etherpad]'
  end
end

directory "#{node['etherpad-lite']['etherpad']['install_dir']}/logs" do
  owner 'etherpad'
  group 'etherpad'
  mode 00755
end

template '/etc/init.d/etherpad' do
  source 'etherpad.init.erb'
  owner 'root'
  group 'root'
  variables :etherpad => node['etherpad-lite']['etherpad']
end

service 'etherpad' do
  supports [:start, :stop, :restart, :status]
  action :start
end