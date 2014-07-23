default[:fluentd_bundle][:gemfile][:sources] = [
  'http://production.cf.rubygems.org'
]

default[:fluentd_bundle][:gemfile][:gems] = {
  'fluentd' => '',
  'fluent-plugin-secure-forward' => '',
  'fluent-plugin-s3' => '',
  'fluent-plugin-elasticsearch' => ''
}
