describe package('nginx') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
  its('protocol') { should include 'tcp'}
  its('protocol') { should include 'tcp6'}
  its('process') { should include 'nginx.conf' }
end

describe port(443) do
  it { should be_listening }
  its('protocol') { should include 'tcp'}
  its('protocol') { should include 'tcp6'}
  its('process') { should include 'nginx.conf' }
end

nginx_config_options = {
  assignment_re: /^\s*([a-z_]+)\s+(.*?)\s*;\s*$/,
  multiple_values: true
}
describe parse_config_file('/etc/nginx/sites-enabled/review.typo3.org', nginx_config_options) do
  its('server_name') { should include 'review.typo3.org'}
  its('add_header') { should include 'Strict-Transport-Security "max-age=31536000; includeSubdomains; preload;"' }
end