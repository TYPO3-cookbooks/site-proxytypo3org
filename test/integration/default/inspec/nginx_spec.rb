control 'nginx-1' do
  title 'Nginx Setup'
  desc '
    Check that nginx is installed and listening to ports
  '

  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_running }
  end

  [80, 443].each do |port|
    describe port(port) do
      it { should be_listening }
      # this is currently broken in InSpec (because the now use "ss" instead of "netstat")
      # https://github.com/chef/inspec/pull/2243
      # its('processes') { should include 'nginx' }
      its('protocols') { should include 'tcp'}
      # its('protocols') { should include 'tcp6'}
    end
  end

  # nginx_config_options = {
  #   assignment_regex: /^\s*([a-z_]+)\s+(.*?)\s*;\s*$/,
  #   multiple_values: true
  # }
  #
  # nginx_config_section = {
  #   assignment_regex: /^\s*([a-z_]+)\s+(.*?)\s*{\s*$/
  # }
  #
  # # default parameters
  # describe parse_config_file('/etc/nginx/sites-enabled/test.vagrant', nginx_config_options) do
  #   its('server_name') { should include 'test.vagrant'}
  #   its('add_header') { should include 'Strict-Transport-Security "max-age=31536000; includeSubdomains; preload;"' }
  # end
  #
  # # specifying a 301 redirect
  # describe parse_config_file('/etc/nginx/sites-enabled/redirect.typo3.org', nginx_config_options) do
  #   its('server_name') { should include 'redirect.typo3.org'}
  #   its('return') { should include '301 https://typo3.org' }
  # end
  #
  # # specified locations in data bag (test for locations to exist)
  # describe parse_config_file('/etc/nginx/sites-enabled/test_location.example.org', nginx_config_section) do
  #   its('location') { should include '/' }
  #   its('location') { should include '/test' }
  #   # just to verify that the test is correct
  #   its('location') { should_not include '/something-that-does-not-exist' }
  # end
  #
  # # specified locations in data bag (test for options to exist)
  # describe parse_config_file('/etc/nginx/sites-enabled/test_location.example.org', nginx_config_options) do
  #   # specified in the data bag
  #   its('proxy_http_version') { should include '1.1' }
  #   # implicit from the data bag
  #   its('proxy_pass') { should include 'http://192.0.2.1:80' }
  #   # specified in the attributes
  #   its('proxy_set_header') { should include 'Proxy ""' }
  # end

  # using action: delete, verify that the site got deleted (will be created in the test cookbook)
  %w{/etc/nginx/sites-enabled/test.action.delete /etc/nginx/sites-available/test.action.delete}.each do |file_to_be_deleted|
    describe file(file_to_be_deleted) do
      it { should_not exist }
    end
  end
end

control 'nginx-proxy' do
  title 'Verify proxy functionality'
  desc 'Check that typo3.org config works'

  # redirect port 80
  describe command('curl --head --resolve "typo3.org:80:127.0.0.1" http://typo3.org') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '301 Moved Permanently' }
  end

  # port 443 to typo3.org works
  describe command('curl --insecure --resolve "typo3.org:443:127.0.0.1" https://typo3.org') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include 'Download TYPO3' }
  end

  # headers
  describe command('curl --head --insecure --resolve "typo3.org:443:127.0.0.1" https://typo3.org') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /Strict-Transport-Security: max-age=15768000; preload;/i }
    its('stdout') { should match /X-Content-Type-Options: nosniff/i }
    its('stdout') { should match /X-Frame-Options: SAMEORIGIN/i }
    its('stdout') { should match /XSS-Protection: 1; mode=block/i }
  end

  # do NOT set includeSubdomains flag for HSTS as this would break non-HTTPS subdomains
  describe command('curl --head --insecure --resolve "typo3.org:443:127.0.0.1" https://typo3.org') do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not match /Strict-Transport-Security: .*includeSubdomains/mi }
  end
end
