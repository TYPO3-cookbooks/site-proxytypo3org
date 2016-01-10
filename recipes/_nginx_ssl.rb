include_recipe "ssl_certificates"

certname = node['site-proxytypo3org']['ssl_certificate']
ssl_certificate certname do
  ca_bundle_combined true
end


template File.join(node['nginx']['dir'], 'conf.d', 'ssl.conf') do
  source 'ssl.conf.erb'
  variables(
    :ssl_certificate     => "#{node['ssl_certificates']['path']}/#{certname}.crt",
    :ssl_certificate_key => "#{node['ssl_certificates']['path']}/#{certname}.key",
    :ssl_dhparam         => "#{node['ssl_certificates']['path']}/#{certname}.dh.pem",
  )
  notifies :reload, 'service[nginx]'
end
