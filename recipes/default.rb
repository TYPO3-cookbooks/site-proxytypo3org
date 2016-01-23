#
# Cookbook Name:: site-proxytypo3org
# Recipe:: default
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association

include_recipe "t3-base"

# TODO remove that, once we don't install Zabbix from source anymore
include_recipe "build-essential"

include_recipe "#{cookbook_name}::_nginx"
include_recipe "#{cookbook_name}::_haproxy"
include_recipe "#{cookbook_name}::_logrotate"
