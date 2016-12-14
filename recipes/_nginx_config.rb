########################
# Default sites
#
# Set up defaults sites for port 80 and 443 that redirect to typo3.org.
########################
{
  "http"  => "80",
  "https" => "443 ssl http2"
}.each do |protocol, listen|

  nginx_conf_file "default-#{protocol}" do
    listen(
      ["#{listen} default", "[::]:#{listen} default"]
    )
    site_type :static
    ssl nil if protocol == "https"
    template "nginx_site.erb"
    cookbook cookbook_name
    options(
      "return" => "301 https://typo3.org"
    )
  end

end

template File.join(node['nginx']['dir'], 'conf.d', 'limits.conf') do
  source 'limits.conf.erb'
  notifies :reload, 'service[nginx]'
end
