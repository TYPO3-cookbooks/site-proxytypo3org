default['haproxy']['enable_default_http'] = false

default['haproxy']['global_options']['stats socket /var/run/haproxy/info.sock'] = "mode 666 level user"
