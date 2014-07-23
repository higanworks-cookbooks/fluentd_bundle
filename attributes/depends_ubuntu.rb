default[:fluentd_bundle][:dep_pkg][:ubuntu] = [
  'libcurl3',
  'libcurl4-openssl-dev'
]

default[:fluentd_bundle][:logrotate] = {
  :set => true,
  :gen => 12
}

