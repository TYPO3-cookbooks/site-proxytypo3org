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