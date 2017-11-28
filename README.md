# Description

This cookbook empowers the proxy instances in front of (hopefully one day) all publicly reachable typo3.org sites.

It installs

* `nginx` for HTTPS termination (including redirect from HTTP to HTTPS)
* `haproxy` for all other port redirections
# Requirements

## Platform:

* debian (> 8.0)

## Cookbooks:

* t3-base (~> 0.2.59)
* zabbix-custom-checks (~> 0.2.0)
* ssl_certificates
* build-essential
* nginx (= 7.0.0)
* nginx_conf (= 2.0.0)
* logrotate (= 1.9.2)
* haproxy (= 2.0.2)
* openssl (= 4.4.0)
* #<Logger:0x00007fcf1a9ec690> () (Recommended but not required)
* #<Logger:0x00007fcf1a9ec690> () (Suggested but not required)
* Conflicts with #<Logger:0x00007fcf1a9ec690> ()

# Attributes

* `node['haproxy']['incoming_address']` - Listen to IPv4 and IPv6. Defaults to `::`.
* `node['haproxy']['enable_default_http']` - Disable the default http loadbalancer that the haproxy cookbook sets up. Defaults to `false`.
* `node['haproxy']['global_options']['stats socket /var/run/haproxy/info.sock']` - Enable a stats socket that is readable e.g. for the zabbix user. Defaults to `mode 666 level user`.
* `node['nginx']['upstream_repository']` - Use Nginx.org's mainline repo. Defaults to `http://nginx.org/packages/mainline/debian`.
* `node['site-proxytypo3org']['nginx']['version']` - Use APT pinning to not accidently upgrade the version of `nginx`. Defaults to `version_map.fetch(node['lsb']['codename'].to_sym)`.
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

```javascript
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

```javascript
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

Optionally, additional parameters can be specified using the `options` and `locations` keys:

```javascript
{
  "id": "example.org",
  "name": "example.org",
  "nginx": {
    "backend": "http://backend.example.org:80",
    "options": {
      "add_header": {
        "Strict-Transport-Security": "\"max-age=15768000; preload;\""
      }
    },
    "locations": {
      "/api/": {
        "proxy_pass":  "http://api.example.org/",
        "proxy_set_header": "Host api.example.org"
      }
    }
  }
}
```

### Redirect

The following snippet can be used send a redirect from subdomain `redirect.example.org` to `example.org`:

```javascript
{
  "id": "redirect.example.org",
  "name": "redirect.example.org",
  "nginx": {
    // backend needs to be filled
    "backend": "http://does.not.matter.example.org:80",
    "options": {
      "return 301": "https://example.org"
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


```javascript
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


## HAProxy Configs

For non-HTTP traffic, HAproxy serves for load balancing / redirection of traffic towards the backends.

This cookbook passes all data bag information to the [`haproxy_lb`](https://github.com/sous-chefs/haproxy/blob/v2.0.2/README.md#haproxy_lb) resource (implemented in [`site-proxytypo3org::_haproxy_sites`](https://github.com/TYPO3-cookbooks/site-proxytypo3org/blob/master/recipes/_haproxy_sites.rb)).

### Simple HAProxy Config

The following minimum viable example forwards the proxies' port `12345` to `srv123.example.org:12345`

```javascript
{
  "id": "foo.example.org",
  "name": "foo.example.org",
  "haproxy": {
    "foo-12345": {
      "mode": "tcp",
      "bind": ":::12345 v4v6",
      "servers": [
        "srv123 srv123.example.org:12345 check"
      ]
    }
  }
}

```

### Parametrized Config

If additional parameters for the HAproxy config need to be specified, these have to be supplied using `params`:

```javascript
{
  "id": "parametrized.example.org",
  "name": "parametrized.example.org",
  "haproxy": {
    "parametrized-12345": {
      "mode": "tcp",
      "bind": ":::12345 v4v6",
      // parameters supplied to the haproxy_lb resource
      "params": {
        // don't close the connection too early
        "timeout tunnel": "3m"
      },
      "servers": [
        "srv123 srv123.example.org:12345 check"
      ]
    }
  }
}
```

### Deletion

There is no need to explicitly delete HAproxy configs. If the data bag item is removed, the next chef run will not include it anymore.


# License and Maintainer

Maintainer:: Steffen Gebert (<steffen.gebert@typo3.org>)



License:: Apache2
