node[:fluentd_bundle][:dep_pkg][:smartos].each do |pkg|
  package pkg
end

## Memo for smartos
## bundle config build.nokogiri --use-system-libraries

node.run_state[:fluentd_bundle][:bundler_pre_commands] << 'bundle config build.nokogiri --use-system-libraries'
