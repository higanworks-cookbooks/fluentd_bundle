default[:fluentd_bundle][:root] = '/opt/fluentd'
default[:fluentd_bundle][:ug] = {
  :user => 'fluentd',
  :uid  => nil,
  :group => 'fluentd',
  :gid  => nil
}
