node.default[:rbenv][:group_users] = [node[:rbenv][:group_users], node[:fluentd_bundle][:ug][:user]].flatten

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'


rbenv_ruby node[:fluentd_bundle][:ruby][:version]

node[:fluentd_bundle][:ruby][:gems].each do |gem|
  rbenv_gem gem do
    ruby_version node[:fluentd_bundle][:ruby][:version]
  end
end

file File.join(node[:fluentd_bundle][:root], '.ruby-version') do
  action :nothing
  content node[:fluentd_bundle][:ruby][:version]
  owner node[:fluentd_bundle][:ug][:user]
  group node[:fluentd_bundle][:ug][:group]
end

node.run_state[:fluentd_bundle][:rbenv_versionfile] = true
