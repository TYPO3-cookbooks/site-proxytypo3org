#<> Use Nginx.org's mainline repo
default['nginx']['upstream_repository'] = "http://nginx.org/packages/mainline/debian"
version_map = {jessie: '1.9.9-1~jessie', stretch: '1.13.6-1~stretch'}
#<> Use APT pinning to not accidently upgrade the version of `nginx`
default['site-proxytypo3org']['nginx']['version'] = version_map.fetch(node['lsb']['codename'].to_sym)
#<> Deploy our wildcard certificate
default['site-proxytypo3org']['ssl_certificate'] = "wildcard.typo3.org"
#<> Disable Nginx default site
default['nginx']['default_site_enabled'] = false
#<> Disable server tokens
default['nginx']['server_tokens'] = 'off'
#<> Allow uploads of up to 25M
default['nginx']['client_max_body_size'] = "25M"
#<> Let slow TYPO3 some more time..
default['nginx']['proxy_read_timeout'] = "180"
#<> raise variables_hash_bucket_size
default['nginx']['variables_hash_bucket_size'] = '128'
#<> Set HTTP Strict Transport Security header by default
default['nginx_conf']['options']['add_header'] = {
  "Strict-Transport-Security" => '"max-age=31536000; includeSubdomains; preload;"',
  "X-Content-Type-Options" => 'nosniff',
  "X-Frame-Options" => 'SAMEORIGIN',
  "X-XSS-Protection" => '"1; mode=block"',

}
default['nginx_conf']['options']['proxy_hide_header'] = [
  'Strict-Transport-Security',
  'X-Content-Type-Options',
  'X-Frame-Options',
  'X-XSS-Protection'
]
#<> Configure default locations for all vhosts
default['nginx_conf']['locations'] = {
  '/' => {
    'proxy_set_header' => {
      'Host' => '$http_host',
      'X-Forwarded-For' => '$proxy_add_x_forwarded_for',
      'X-Forwarded-Port' => '$server_port',
      'X-Forwarded-Proto' => '$scheme',
      'X-Real-IP' => '$remote_addr',
      'HTTPS' => 'on', # we only use HTTPS on this proxy (except for redirect vhosts)
      'Proxy' => '""', # mitigate httpoxy vulnerability
    },
    'proxy_redirect' => 'off',
    'proxy_pass' => nil
  }
}
#<> We do not use unix sockets, so revert the stupid assumption by the [nginx_conf](https://github.com/tablexi/chef-nginx_conf) cookbook
default['nginx_conf']['pre_socket'] = ''
