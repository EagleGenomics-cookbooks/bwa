#
# Cookbook Name:: bwa
# Recipe:: default
#
# Copyright 2016 Eagle Genomics Ltd
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

include_recipe 'apt' if platform?('debian', 'ubuntu')

include_recipe 'build-essential'

package ['tar'] do
  action :install
end

package 'zlib-devel' do
  package_name case node['platform_family']
               when 'rhel'
                 'zlib-devel'
               when 'debian'
                 'zlib1g-dev'
               end
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['bwa']['filename']}" do
  source node['bwa']['url']
  action :create_if_missing
end

execute 'extract tar ball to install directory' do
  command "tar xjf #{Chef::Config[:file_cache_path]}/#{node['bwa']['filename']} -C #{node['bwa']['install_path']}"
  not_if { ::File.exist?(node['bwa']['dir']) }
end

execute 'make' do
  cwd node['bwa']['dir']
  not_if { ::File.exist?("#{node['bwa']['dir']}/bwa") }
end

# cannot use link with wild cards
execute 'create symbolic links in PATH to bwa executables' do
  command "ln -s -f #{node['bwa']['dir']}/bwa ."
  cwd node['bwa']['bin_path']
end

execute 'make bwa symbolic links executable' do
  command "chmod -R 755 #{node['bwa']['install_path']}/bin/*"
  cwd node['bwa']['bin_path']
end
