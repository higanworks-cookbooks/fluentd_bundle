default[:fluentd_bundle][:dep_pkg][:smartos] = [
]

## bundle config build.nokogiri --use-system-libraries

if node[:platform] == 'smartos'
  default[:fluentd_bundle][:logadm] = {
    :set => true,
    :gen => '12w'
  }
end
