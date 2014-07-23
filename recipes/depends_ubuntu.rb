node[:fluentd_bundle][:dep_pkg][:ubuntu].each do |pkg|
  package pkg
end

template "/etc/logrotate.d/fluentd_bundle" do
  source 'logrotate.erb'
  variables node[:fluentd_bundle][:logrotate]
end if node[:fluentd_bundle][:logrotate][:set]
