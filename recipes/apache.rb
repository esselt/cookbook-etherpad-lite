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

settings = []
settings['host'] = node['etherpad-lite']['etherpad']['host']
settings['port'] = node['etherpad-lite']['etherpad']['port']
settings['domain'] = node['etherpad-lite']['apache']['domain']
settings['ssl_enable'] = node['etherpad-lite']['apache']['ssl_enable']
settings['ssl_cert'] = node['etherpad-lite']['apache']['ssl_cert']
settings['ssl_key'] = node['etherpad-lite']['apache']['ssl_key']

web_app settings['domain'] || node['fqdn'] do
  template 'web_app.erb'

  host settings['host']
  port settings['port']
  domain settings['domain']

  ssl_enable settings['ssl_enable']
  ssl_cert settings['ssl_cert']
  ssl_key settings['ssl_key']

  enable true
end