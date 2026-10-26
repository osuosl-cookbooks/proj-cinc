require_relative '../../spec_helper'

describe 'proj-cinc::omnitruck' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do
          stub_command('iptables -C INPUT -j REJECT --reject-with icmp-host-prohibited 2>/dev/null').and_return(false)
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { is_expected.to include_recipe('osl-docker') }
      it { is_expected.to_not include_recipe('osl-firewall::default') }
      it { is_expected.to include_recipe('osl-git') }

      it do
        is_expected.to sync_git('/opt/omnitruck').with(
          repository: 'https://gitlab.com/cinc-project/distribution/omnitruck.git',
          revision: 'main'
        )
      end

      it do
        expect(chef_run.git('/opt/omnitruck')).to \
          notify('osl_dockercompose[omnitruck]').to(:rebuild)
      end

      it do
        is_expected.to create_template('/opt/omnitruck/.env').with(
          source: 'omnitruck.env.erb',
          variables: { port: 8081 }
        )
      end

      it do
        expect(chef_run).to render_file('/opt/omnitruck/.env').with_content(/^PORT=8081$/)
      end

      it do
        expect(chef_run.template('/opt/omnitruck/.env')).to \
          notify('osl_dockercompose[omnitruck]').to(:rebuild)
      end

      it do
        is_expected.to pull_docker_image('cincproject/omnitruck-cinc-sh').with(
          tag: 'latest'
        )
      end

      it do
        expect(chef_run.docker_image('cincproject/omnitruck-cinc-sh')).to \
          notify('osl_dockercompose[omnitruck]').to(:rebuild)
      end

      it do
        is_expected.to up_osl_dockercompose('omnitruck').with(
          directory: '/opt/omnitruck',
          config_files: %w(compose.yml)
        )
      end

      it do
        is_expected.to accept_osl_firewall_port('cinc-omnitruck').with(
          service_name: 'omnitruck',
          ports: %w(8081),
          osl_only: true
        )
      end
    end
  end
end
