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
* `node['nginx']['proxy_read_timeout']` - Let slow TYPO3 some more time.. Defaults to `180`.
* `node['nginx_conf']['options']['add_header']` - Set HTTP Strict Transport Security header by default. Defaults to `{ ... }`.
* `node['nginx_conf']['locations']` - Configure default locations for all vhosts. Defaults to `{ ... }`.
* `node['nginx_conf']['pre_socket']` - We do not use unix sockets, so revert the stupid assumption by the [nginx_conf](https://github.com/tablexi/chef-nginx_conf) cookbook. Defaults to ``.

# Recipes

* site-proxytypo3org::default

# Data Bags

This cookbook searches the `proxy` data bag and installs Nginx and/or HAproxy sites for each of them.

Example data bags can be found in the [`test/integration/data_bags/proxy/`](https://github.com/TYPO3-cookbooks/site-proxytypo3org/tree/master/test/integration/data_bags/proxy) folder.

## Data Bag Format

The basic data bag format looks as follows:

```json
{
  "id": "example.org",
  "name": "example.org",
  // optional: nginx site
  "nginx": {
    // ...
  },
  // optional: haproxy configs
  "haproxy": {
  }
}
```

If neither `nginx`, nor `haproxy` keys are specified, the data bag item is ignored.

_Note:_ Fortunately, Chef / Ruby allows comments within data bag JSON. Please make use of that!

## Nginx Sites

This cookbook passes all data bag information to the [`nginx_conf_file`](https://github.com/tablexi/chef-nginx_conf/tree/v1.0.1#create) resource (implemented in [`site-proxytypo3org::_nginx_sites`](https://github.com/TYPO3-cookbooks/site-proxytypo3org/blob/master/recipes/_nginx_sites.rb)).

### Simple Nginx Example

Every proxy site needs a backend specified (minimum viable example):

```json
{
  "id": "example.org",
  "name": "example.org",
  "nginx": {
    // mandatory parameter pointing to the backend
    "backend": "http://backend.example.org:80"
  }
}
```

### Parametrized Site

Optionally, additional parameters can be specified using the `options` key:

```json
{
  "id": "example.org",
  "name": "example.org",
  "nginx": {
    "backend": "http://backend.example.org:80",
    "options": {
      "add_header": {
        "Strict-Transport-Security": "\"max-age=15768000; preload;\""
      },
      "locations": {
        "/api/": {
          "proxy_pass":  "http://api.example.org/",
          "proxy_set_header": "Host api.example.org"
        }
      }
    }
  }
}
```

### Actions / Deletion

THe following actions are allowed:

- `create` (default): Create and enable the nginx vhost
- `delete`: Disable and delete
- `enable`: Enables a previously disbled site
- `disable`: Disables a site but leaves configuration in `/etc/nginx/sites-available/`.


```json
{
  "id": "example.org",
  "name": "example.org",
  "action": "delete",
  "nginx": {
    // the action might be specified here as well
    "action": "delete",
    // sorry, the backend parameter is still mandatory
    "backend": "http://example.org:80"
  }
}
```

The `action` key can be specified both on top level, as well as below the `nginx` key. The effect is the same: It will be only applied to Nginx (the HAprox cookbook does not need explicit deletion).

# License and Maintainer

Maintainer:: Steffen Gebert (<steffen.gebert@typo3.org>)

License:: Apache2
