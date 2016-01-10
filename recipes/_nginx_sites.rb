#
# Cookbook Name:: site-proxytypo3org
# Recipe:: default
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association


sites = search(:proxy, "nginx:*")
sites.each do |site|
  log "Processing nginx proxy site #{site}"

  nginx_conf_file site['name'] do
    socket site['nginx']['backend']
    template "nginx_site.erb"
    cookbook cookbook_name
    options site['nginx']['options'] || {}
  end

end
