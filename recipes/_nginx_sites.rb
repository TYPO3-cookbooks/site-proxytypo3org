#
# Cookbook Name:: site-proxytypo3org
# Recipe:: default
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association


sites = search(:proxy, "nginx:*")
sites.each do |site|
  log "Processing nginx proxy site #{site}"

  specified_action = site['nginx']['action'] || site['action']
  if specified_action
    valid_actions = %w{create delete enable disable}
    raise "Action '#{specified_action}' for site #{site['name']} is invalid. Valid options are #{valid_actions.implode(', ')}" unless valid_actions.include? specified_action
  end

  locations = Chef::Mixin::DeepMerge.deep_merge!(node['nginx_conf']['locations'], site['nginx']['locations'])

  # HTTPS vhost
  nginx_conf_file site['name'] do
    listen(["443 ssl http2", "[::]:443 ssl http2"])
    socket site['nginx']['backend']
    # using our custom template, we don't have to supply certificate/key data here..
    ssl nil
    template "nginx_site.erb"
    cookbook cookbook_name
    locations locations
    options site['nginx']['options'] || {}
    action specified_action || :create
  end

  # HTTP vhost, redirecting to HTTPS
  nginx_conf_file site['name'] + "-redirect" do
    listen ["80", "[::]:80"]
    server_name site['name']
    site_type :static
    options(
      "return" => "301 https://$server_name$request_uri"
    )
    action specified_action || :create
  end

end
