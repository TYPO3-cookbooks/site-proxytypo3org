name             "site-proxytypo3org"
maintainer       "Steffen Gebert"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache2"
description      "Installs/Configures site-proxytypo3org"
long_description "Installs/Configures site-proxytypo3org, the proxy in front of *.typo3.org"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.0.1'

supports         "debian",     "> 8.0"

depends          "t3-base",    "~> 0.2.59"
depends          "zabbix-custom-checks", "~> 0.2.0"
depends          "ssl_certificates"

depends          "nginx",      "= 7.0.0"
depends          "nginx_conf", "= 2.0.0"
depends          "logrotate",  "= 1.9.2"
depends          "haproxy",    "= 2.0.2"
depends          "openssl",    "= 4.4.0"
depends          "build-essential",      "= 2.2.4"
