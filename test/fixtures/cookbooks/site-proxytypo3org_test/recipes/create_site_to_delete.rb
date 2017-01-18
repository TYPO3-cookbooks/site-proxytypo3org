# test "action": "delete"
# create a site that should be deleted during the regular run

# this recipe has to run _before_ site-proxytypo3org::_nginx_sites starts,
# so we hook into a resource that runs bevore (in ::_nginx_config)

nginx_conf_file "test.action.delete" do
  listen(["443 ssl http2", "[::]:443 ssl http2"])
  socket "http://example.org:80"
  subscribes :create, "nginx_conf_file[default-http]", :before
end