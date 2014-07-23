default[:fluentd_bundle][:use_rbenv] = true
default[:fluentd_bundle][:ruby][:version] = value_for_platform(
  ["smartos" ] => {
   "default" => "1.9.3p547"
  },
  "default" => "2.1.2"
)


default[:fluentd_bundle][:ruby][:gems] = ['bundler']
