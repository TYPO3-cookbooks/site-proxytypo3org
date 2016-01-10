# looks like node['nginx']['default_site_enabled'] does not match this
file "/etc/nginx/conf.d/default.conf" do
  action :delete
end