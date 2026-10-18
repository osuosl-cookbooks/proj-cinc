control 'omnitruck' do
  describe file('/opt/omnitruck/compose.yml') do
    it { should exist }
  end

  describe file('/opt/omnitruck/.env') do
    it { should exist }
    its('content') { should match(/^PORT=8081$/) }
  end

  %w(valkey omnitruck poller).each do |svc|
    describe json(content: command("docker compose -p omnitruck -f /opt/omnitruck/compose.yml ps #{svc} --format json").stdout) do
      its(%w(State)) { should eq 'running' }
    end
  end

  describe http('http://127.0.0.1:8081/_healthz') do
    its('status') { should eq 204 }
  end

  # Both read valkey, so they return 404 until the poller's first pass finishes
  describe http('http://127.0.0.1:8081/_status') do
    its('status') { should eq 200 }
    its('body') { should match(/"timestamp"/) }
  end

  describe http('http://127.0.0.1:8081/stable/cinc/metadata?p=el&pv=10&m=x86_64') do
    its('status') { should eq 200 }
    its('body') { should match(/packages\.cinc\.sh/) }
  end
end
