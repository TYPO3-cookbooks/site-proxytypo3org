#<> Listen to IPv4 and IPv6
default['haproxy']['incoming_address'] = "::"
#<> Disable the default http loadbalancer that the haproxy cookbook sets up
default['haproxy']['enable_default_http'] = false
#<> Enable a stats socket that is readable e.g. for the zabbix user
default['haproxy']['global_options']['stats socket /var/run/haproxy/info.sock'] = "mode 666 level user"

