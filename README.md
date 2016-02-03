# Description

This cookbook empowers the proxy instances in front of (hopefully one day) all publicly reachable typo3.org sites.

It installs

* `nginx` for HTTPS termination (including redirect from HTTP to HTTPS)
* `haproxy` for all other port redirections
# Requirements

## Platform:

* debian (> 8.0)

## Cookbooks:

* t3-base (~> 0.2.0)
* zabbix-custom-checks (~> 0.2.0)
* ssl_certificates
* nginx (= 2.7.6)
* nginx_conf (= 1.0.1)
* logrotate (= 1.9.2)
* haproxy (= 1.6.7)
* openssl (= 4.4.0)
* build-essential (= 2.2.4)

# Attributes

* `node['haproxy']['incoming_address']` - Listen to IPv4 and IPv6. Defaults to `::`.
* `node['haproxy']['enable_default_http']` - Disable the default http loadbalancer that the haproxy cookbook sets up. Defaults to `false`.
* `node['haproxy']['global_options']['stats socket /var/run/haproxy/info.sock']` - Enable a stats socket that is readable e.g. for the zabbix user. Defaults to `mode 666 level user`.
* `node['nginx']['upstream_repository']` - Use Nginx.org's mainline repo. Defaults to `http://nginx.org/packages/mainline/debian`.
* `node['site-proxytypo3org']['nginx']['version']` - Use APT pinning to not accidently upgrade the version of `nginx`. Defaults to `1.9.9-1~jessie`.
* `node['site-proxytypo3org']['ssl_certificate']` - Deploy our wildcard certificate. Defaults to `wildcard.typo3.org`.
* `node['nginx']['default_site_enabled']` - Disable Nginx default site. Defaults to `false`.
* `node['nginx']['client_max_body_size']` - Allow uploads of up to 25M. Defaults to `25M`.
* `node['nginx_conf']['options']['add_header']` - Set HTTP Strict Transport Security header by default. Defaults to `{ ... }`.
* `node['nginx_conf']['locations']` - Configure default locations for all vhosts. Defaults to `{ ... }`.
* `node['nginx_conf']['pre_socket']` - We do not use unix sockets, so revert the stupid assumption by the [nginx_conf](https://github.com/tablexi/chef-nginx_conf) cookbook. Defaults to ``.

# Recipes

* site-proxytypo3org::default

# License and Maintainer

Maintainer:: Steffen Gebert (<steffen.gebert@typo3.org>)

License:: Apache2
