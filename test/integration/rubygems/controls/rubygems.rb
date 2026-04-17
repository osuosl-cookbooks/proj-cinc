control 'rubygems' do
  describe directory('/opt/rubygems.cinc.sh') do
    it { should exist }
  end

  describe directory('/data/rubygems.cinc.sh') do
    it { should exist }
  end

  describe file('/opt/rubygems.cinc.sh/compose.yml') do
    it { should exist }
  end

  describe file('/opt/rubygems.cinc.sh/nginx.conf') do
    it { should exist }
  end

  describe file('/opt/rubygems.cinc.sh/.env') do
    it { should exist }
    its('mode') { should cmp '0400' }
  end

  %w(geminabox nginx).each do |svc|
    describe json(content: command("docker compose -p rubygems-cinc-sh -f /opt/rubygems.cinc.sh/compose.yml ps #{svc} --format json").stdout) do
      its(%w(State)) { should eq 'running' }
    end
  end

  describe http('http://127.0.0.1:8080') do
    its('status') { should eq 200 }
    its('body') { should match(/Cinc RubyGems/) }
  end
end
