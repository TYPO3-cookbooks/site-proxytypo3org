#
# Cookbook Name:: site-proxytypo3org
# Recipe:: _haproxy
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association


include_recipe "#{cookbook_name}::_haproxy_sites"

include_recipe "haproxy"

include_recipe "zabbix-custom-checks::haproxy"