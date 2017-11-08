#
# Cookbook Name:: site-proxytypo3org
# Recipe:: _haproxy
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association


include_recipe "#{cookbook_name}::_haproxy_sites"

# create the directory, where we want our stats socket
directory "/var/run/haproxy"

include_recipe "haproxy::manual"

#include_recipe "zabbix-custom-checks::haproxy" unless node['dev_mode']
