#
# Cookbook Name:: etherpad-lite
# Recipe:: apahce
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

params = node['etherpad-lite'].dup
variables = {
  'vhost_template'  => 'apache.vhost.erb',
  'vhost_cookbook'  => 'etherpad-lite',

  'server_name'     => params['domain'],
  'server_ip'       => params['ip_address'],
  'logroot'         => params['logs_dir'],
  'other'           => {
    'internal_port' => params['port_number']
  }
}

node.default['lamp-stack']['websites'] = {
  params['domain'] => variables
}

include_recipe 'lamp-stack::apache'
include_recipe 'apache2::mod_proxy_http'