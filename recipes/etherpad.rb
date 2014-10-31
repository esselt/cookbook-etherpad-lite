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

case node['platform_family']
  when "debian", "ubuntu"
    packages = %w{gzip git-core curl python libssl-dev pkg-config build-essential}
  when "fedora","centos","rhel"
    packages = %w{gzip git-core curl python openssl-devel}
  # && yum groupinstall "Development Tools"
end

packages.each do |p|
  package p
end

user = node['etherpad-lite']['service_user']
user_id = node['etherpad-lite']['service_uid']
group_id = node['etherpad-lite']['service_gid']
user_home = node['etherpad-lite']['service_user_home']
project_path = "#{user_home}/etherpad-lite"

group user do
  gid group_id
end

user user do
  uid user_id
  gid group_id
  home user_home
  supports :managed_home => true
  system true
  comment 'Service user for Etherpad'
end

git project_path do
  repository node['etherpad-lite']['etherpad_git_repo_url']
  action :sync
  user user
end

template "#{project_path}/settings.json" do
  owner user
  group user
  variables({
    :title => node['etherpad-lite']['title'],
    :favicon_url => node['etherpad-lite']['favicon_url'],
    :ip_address => node['etherpad-lite']['ip_address'],
    :port_number => node['etherpad-lite']['port_number'],
    :session_key => node['etherpad-lite']['session_key'],
    :db_type => node['etherpad-lite']['db_type'],
    :db_user => node['etherpad-lite']['db_user'],
    :db_host => node['etherpad-lite']['db_host'],
    :db_password => node['etherpad-lite']['db_password'],
    :db_name => node['etherpad-lite']['db_name'],
    :default_text => node['etherpad-lite']['default_text'],
    :require_session => node['etherpad-lite']['require_session'],
    :edit_only => node['etherpad-lite']['edit_only'],
    :minify => node['etherpad-lite']['minify'],
    :max_age => node['etherpad-lite']['max_age'],
    :abiword_path => node['etherpad-lite']['abiword_path'],
    :require_authentication => node['etherpad-lite']['require_authentication'],
    :require_authorization => node['etherpad-lite']['require_authorization'],
    :admin_enabled => node['etherpad-lite']['admin_enabled'],
    :admin_password => node['etherpad-lite']['admin_password'],
    :log_level => node['etherpad-lite']['log_level']
  })
end

etherpad_api_key = node['etherpad-lite']['etherpad_api_key']

if etherpad_api_key != ''
  template "#{project_path}/APIKEY.txt" do
    owner user
    group user
    variables({
      :etherpad_api_key => etherpad_api_key
    })
  end
end

bash 'etherpad-installdeps' do
  user 'root'
  cwd project_path
  code <<-EOH
  ./bin/installDeps.sh >> #{error_log}
  EOH
end

node_modules = project_path + '/node_modules'

directory node_modules do
  owner user
  group user
  mode '770'
  recursive true
  action :create
end

unless node['etherpad-lite']['plugins'].empty?
  node['etherpad-lite']['plugins'].each do |plugin|
    plugin_npm_module = "ep_#{plugin}"
    nodejs_npm plugin_npm_module do
      path project_path
      user user
      group user
      action :install
      notifies :restart, "service[#{node['etherpad-lite']['service_name']}]"
    end
  end
end

log_dir = node['etherpad-lite']['logs_dir']
access_log = log_dir + '/access.log'
error_log = log_dir + '/error.log'

directory log_dir do
  owner 'root'
  group user
  mode '2750'
end

template '/etc/init/etherpad.conf' do
  source 'upstart.conf.erb'
  owner 'root'
  group 'root'
  variables({
    :etherpad_installation_dir => project_path,
    :etherpad_service_user => user,
    :etherpad_access_log => access_log,
    :etherpad_error_log => error_log,
  })
end

service node['etherpad-lite']['service_name'] do
  provider Chef::Provider::Service::Upstart
  action :start
end