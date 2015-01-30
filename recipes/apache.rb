#
# Cookbook Name:: etherpad-lite
# Recipe:: apache
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

%w{apache2 apache2::mod_proxy_http}.each do |recipe|
  include_recipe recipe
end

if node['etherpad-lite']['apache']['ssl_enable']
  include_recipe 'apache2::mod_ssl'
end

host = node['etherpad-lite']['etherpad']['host']
port = node['etherpad-lite']['etherpad']['port'].to_s
domain = node['etherpad-lite']['apache']['domain']
ssl_enable = node['etherpad-lite']['apache']['ssl_enable']
ssl_cert = node['etherpad-lite']['apache']['ssl_cert']
ssl_key = node['etherpad-lite']['apache']['ssl_key']

web_app settings['domain'] || node['fqdn'] do
  template 'web_app.erb'

  host host
  port port
  domain domain

  ssl_enable ssl_enable
  ssl_cert ssl_cert
  ssl_key ssl_key

  enable true
end