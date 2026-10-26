#
# Cookbook:: proj-cinc
# Recipe:: omnitruck
#
# Copyright:: 2026, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'osl-docker'
include_recipe 'osl-git'

omnitruck_dir = '/opt/omnitruck'

git omnitruck_dir do
  repository 'https://gitlab.com/cinc-project/distribution/omnitruck.git'
  revision 'main'
  notifies :rebuild, 'osl_dockercompose[omnitruck]'
end

# rubygems.cinc.sh already holds 8080 on this host
template "#{omnitruck_dir}/.env" do
  source 'omnitruck.env.erb'
  variables(port: 8081)
  notifies :rebuild, 'osl_dockercompose[omnitruck]'
end

docker_image 'cincproject/omnitruck-cinc-sh' do
  tag 'latest'
  notifies :rebuild, 'osl_dockercompose[omnitruck]'
end

# Only compose.yml: the upstream compose.override.yml builds from source
osl_dockercompose 'omnitruck' do
  directory omnitruck_dir
  config_files %w(compose.yml)
end

osl_firewall_port 'cinc-omnitruck' do
  service_name 'omnitruck'
  ports %w(8081)
  osl_only true
end
