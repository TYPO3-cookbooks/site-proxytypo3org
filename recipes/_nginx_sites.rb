#
# Cookbook Name:: site-proxytypo3org
# Recipe:: default
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association


sites = search(:proxy, "nginx:*")
sites.each do |site|
  log "Processing nginx proxy site #{site}"

  # HTTPS vhost
  nginx_conf_file site['name'] do
    listen(["443 ssl http2", "[::]:443 ssl http2"])
    socket site['nginx']['backend']
    # using our custom template, we don't have to supply certificate/key data here..
    ssl {}
    template "nginx_site.erb"
    cookbook cookbook_name
    options site['nginx']['options'] || {}
  end

  # HTTP vhost, redirecting to HTTPS
  nginx_conf_file site['name'] + "-redirect" do
    listen ["80", "[::]:80"]
    server_name site['name']
    site_type :static
    options(
      "return" => "301 https://$server_name$request_uri"
    )
  end

end
