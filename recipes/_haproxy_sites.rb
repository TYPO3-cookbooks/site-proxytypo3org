#
# Cookbook Name:: site-proxytypo3org
# Recipe:: _haproxy_sites
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association

sites = search(:proxy, "haproxy:*")
#sites.reject{|site| not site.key?("haproxy")}.each do |site|
sites.each do |site|
  log "Processing haproxy #{site['name']}"

  site['haproxy'].each do |hap_name, hap_data|

    log "Processing frontend #{hap_name}"

    haproxy_lb hap_name do
      bind hap_data['bind']
      mode hap_data['mode']
      servers hap_data['servers']
    end

  end
end
