describe package('haproxy') do
  it { should be_installed }
end

describe service('haproxy') do
  # it { should be_running }
end

describe port(12345) do
  it { should be_listening }
  its('protocols') { should include 'tcp'}
  # its('processes') { should include 'haproxy' }
end
