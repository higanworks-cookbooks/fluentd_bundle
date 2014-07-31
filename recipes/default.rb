#
# Cookbook Name:: fluentd_bundle
# Recipe:: default
#
# Copyright (C) 2014 HiganWorks LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.run_state[:fluentd_bundle] = Mash.new
node.run_state[:fluentd_bundle][:bundler_pre_commands] = node[:fluentd_bundle][:bundler][:pre_commands]

group node[:fluentd_bundle][:ug][:group]

user node[:fluentd_bundle][:ug][:user] do
  system true unless node[:platform] == 'smartos'
  shell '/bin/bash'
  group node[:fluentd_bundle][:ug][:group]
  home node[:fluentd_bundle][:root]
end

include_recipe "#{cookbook_name}::rbenv" if node[:fluentd_bundle][:use_rbenv]

directory node[:fluentd_bundle][:root] do
  owner node[:fluentd_bundle][:ug][:user]
  group node[:fluentd_bundle][:ug][:group]
  notifies :create, "file[#{File.join(node[:fluentd_bundle][:root], '.ruby-version')}]", :immediately if node.run_state[:fluentd_bundle][:rbenv_versionfile]
end

%w{etc etc/conf.d scripts log var tmp}.each do |dir|
  directory File.join(node[:fluentd_bundle][:root], dir) do
    recursive true
    owner node[:fluentd_bundle][:ug][:user]
    group node[:fluentd_bundle][:ug][:group]
  end
end

include_recipe "#{cookbook_name}::depends_#{node[:platform]}" if FluentdBundle::DependsHelper.has_depends?(node)

%W{start.sh stop.sh}.each do |script|
  template File.join(node[:fluentd_bundle][:root], 'scripts', script) do
    source "#{script}.erb"
    mode '0755'
    owner node[:fluentd_bundle][:ug][:user]
    group node[:fluentd_bundle][:ug][:group]
  end
end

template File.join(node[:fluentd_bundle][:root], 'Gemfile') do
  source 'Gemfile.erb'
  variables node[:fluentd_bundle][:gemfile]
  owner node[:fluentd_bundle][:ug][:user]
  group node[:fluentd_bundle][:ug][:group]
  notifies :run, "bash[bundle_for_fluentd]", :immediately
end

bash 'bundle_for_fluentd' do
  if node[:fluentd_bundle][:bundler][:force_bundle]
    action :run
  else
    action :nothing
  end
  environment 'HOME' => node[:fluentd_bundle][:root]
  user node[:fluentd_bundle][:ug][:user]
  cwd node[:fluentd_bundle][:root]
  code <<-EOH
  if [ -f /etc/profile.d/rbenv.sh ];then source /etc/profile.d/rbenv.sh ; fi
  #{node.run_state[:fluentd_bundle][:bundler_pre_commands].join("\n")}
  bundle install --path=vendor/bundle --binstubs --without development,test
  EOH
end
