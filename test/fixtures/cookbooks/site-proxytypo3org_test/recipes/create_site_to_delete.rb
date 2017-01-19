# test "action": "delete"
# create a site that should be deleted during the regular run

# this recipe has to run _before_ site-proxytypo3org::_nginx_sites starts,
# so we hook into a resource that runs bevore (in ::_nginx_config)

log "Creating test site called test.action.delete"

file "/etc/nginx/sites-available/test.action.delete" do
  content "# This file should be deleted"
  action :nothing
  subscribes :create, "nginx_conf_file[default-http]", :before
  end

link "/etc/nginx/sites-enabled/test.action.delete" do
  to "/etc/nginx/sites-available/test.action.delete"
  action :nothing
  subscribes :create, "nginx_conf_file[default-http]", :before
end