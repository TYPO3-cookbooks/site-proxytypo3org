#
# Cookbook Name:: site-proxytypo3org
# Recipe:: _nginx
#
# Copyright (c) 2016 Steffen Gebert / TYPO3 Association

include_recipe "nginx::repo"
include_recipe "nginx::package"

include_recipe "#{cookbook_name}::_nginx_ssl"
include_recipe "#{cookbook_name}::_nginx_config"
include_recipe "#{cookbook_name}::_nginx_sites"