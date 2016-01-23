name             "site-proxytypo3org"
maintainer       "Steffen Gebert"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache2"
description      "Installs/Configures site-proxytypo3org"
long_description "Installs/Configures site-proxytypo3org, the proxy in front of *.typo3.org"
version          "1.0.3"

supports         "debian",     "> 8.0"

depends          "t3-base",    "~> 0.2.0"
depends          "ssl_certificates"

depends          "nginx",      "= 2.7.6"
depends          "nginx_conf", "= 1.0.1"
depends          "logrotate",  "= 1.9.2"
depends          "haproxy",    "= 1.6.7"
depends          "openssl",    "= 4.4.0"
