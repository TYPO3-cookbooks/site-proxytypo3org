#
# Cookbook Name:: site-proxytypo3org
# Recipe:: _nginx
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association

# Optionally pin nginx version
apt_preference "nginx" do
  pin "version #{node['site-proxytypo3org']['nginx']['version']}"
  pin_priority "700"
  only_if { node['site-proxytypo3org']['nginx']['version'] }
end

# We do not use the OS's version, but use the one from nginx mainline
include_recipe "nginx::repo"
include_recipe "nginx::package"

include_recipe "#{cookbook_name}::_nginx_ssl"
include_recipe "#{cookbook_name}::_nginx_config"
include_recipe "#{cookbook_name}::_nginx_sites"

# Zabbix check
include_recipe "zabbix-custom-checks::nginx" unless node['dev_mode']