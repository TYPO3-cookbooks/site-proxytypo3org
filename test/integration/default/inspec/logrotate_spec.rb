control 'logrotate' do
  title 'logrotate config'

  %w{nginx haproxy}.each do |file|
    describe file("/etc/logrotate.d/#{file}") do
      it { should exist }
      its('content') { should include 'daily' }
      its('content') { should_not include 'weekly' }
    end
  end
end
