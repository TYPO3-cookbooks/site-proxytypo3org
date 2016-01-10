default['site-proxytypo3org']['ssl_certificate'] = "wildcard.typo3.org"
default['nginx_conf']['options']['add_header'] = {
  "Strict-Transport-Security" => '"max-age=31536000; includeSubdomains; preload;"'
}

#######################################
# Attributes of upstream cookbooks
#################################
default['nginx']['default_site_enabled'] = false
default['nginx']['upstream_repository'] = 'http://nginx.org/packages/mainline/debian'

default['nginx_conf']['pre_socket'] = ''
