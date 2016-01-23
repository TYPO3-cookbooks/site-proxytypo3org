describe package('haproxy') do
  it { should be_installed }
end

describe service('haproxy') do
  it { should be_running }
end

describe port(29418) do
  it { should be_listening }
  # while it is reachable through IPv6, inspec does not recognize it,
  # as there's no "tcp" line in `netstat -ntl`
  # its('protocols') { should include 'tcp'}
  its('protocols') { should include 'tcp6'}
  its('processes') { should include 'haproxy' }
end
