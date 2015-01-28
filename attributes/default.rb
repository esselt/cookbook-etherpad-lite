#
# Cookbook Name:: etherpad-lite
# Attribute:: default
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

# Defaults based on https://github.com/ether/etherpad-lite/blob/develop/settings.json.template

default['etherpad-lite']['etherpad']['title'] = 'Etherpad'
default['etherpad-lite']['etherpad']['host'] = '127.0.0.1'
default['etherpad-lite']['etherpad']['port'] = 9001
default['etherpad-lite']['etherpad']['session_key'] = ''
default['etherpad-lite']['etherpad']['default_text'] = 'Welcome to Etherpad!\\n\\nThis pad text is synchronized as you type, so that everyone viewing this page sees the same text. This allows you to collaborate seamlessly on documents!\\n\\nGet involved with Etherpad at http:\/\/etherpad.org\\n'
default['etherpad-lite']['etherpad']['group_only'] = false
default['etherpad-lite']['etherpad']['cache_age'] = 21600
default['etherpad-lite']['etherpad']['abiword_path'] = ''
default['etherpad-lite']['etherpad']['force_authentication'] = false
default['etherpad-lite']['etherpad']['force_authorization'] = false
default['etherpad-lite']['etherpad']['enable_admin'] = false
default['etherpad-lite']['etherpad']['admin_user'] = 'admin'
default['etherpad-lite']['etherpad']['admin_password'] = 'ChangeMe'
default['etherpad-lite']['etherpad']['log_level'] = 'INFO'
default['etherpad-lite']['etherpad']['plugins'] = []
default['etherpad-lite']['etherpad']['uid'] = 600
default['etherpad-lite']['etherpad']['gid'] = 600
default['etherpad-lite']['etherpad']['install_dir'] = '/opt/etherpad-lite'
default['etherpad-lite']['etherpad']['git_repo'] = 'git://github.com/ether/etherpad-lite.git'
default['etherpad-lite']['etherpad']['revision'] = 'release/1.5.1'
default['etherpad-lite']['etherpad']['api_key'] = nil

default['etherpad-lite']['apache']['domain'] = nil
default['etherpad-lite']['apache']['ssl_enable'] = false
default['etherpad-lite']['apache']['ssl_cert'] = nil
default['etherpad-lite']['apache']['ssl_key'] = nil

default['etherpad-lite']['mysql']['host'] = '127.0.0.1'
default['etherpad-lite']['mysql']['database'] = 'etherpad'
default['etherpad-lite']['mysql']['user'] = 'etherpad'
default['etherpad-lite']['mysql']['password'] = 'ChangeMeToo'
