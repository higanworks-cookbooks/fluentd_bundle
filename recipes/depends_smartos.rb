node[:fluentd_bundle][:dep_pkg][:smartos].each do |pkg|
  package pkg
end

node.run_state[:fluentd_bundle][:bundler_pre_commands] << 'bundle config build.nokogiri --use-system-libraries'

execute 'fluentd_bundle logadm entry' do
  command "logadm -c -A #{node[:fluentd_bundle][:logadm][:gen]} -z 1 -w fluentd #{node[:fluentd_bundle][:root]}log/fluentd.log"
  only_if { node[:fluentd_bundle][:logadm][:set] }
  not_if "logadm -V | grep #{node[:fluentd_bundle][:root]}log/fluentd.log"
end
