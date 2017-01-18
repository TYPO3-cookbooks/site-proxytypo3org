# test "action": "delete"
# create a site that should be deleted during the regular run

# this recipe has to run _before_ site-proxytypo3org::default

nginx_conf "test.action.delete" do
  listen(["443 ssl http2", "[::]:443 ssl http2"])
  socket "http://example.org:80"
end