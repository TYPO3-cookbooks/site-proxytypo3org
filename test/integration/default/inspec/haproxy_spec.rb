describe package('haproxy') do
  it { should be_installed }
end

describe port(22) do
  it { should be_listening }
  #its('protocol') { should include 'tcp'}
  #its('protocol') { should include 'tcp6'}
  #its('process') { should include 'haproxy' }
end
