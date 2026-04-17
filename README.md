# proj-cinc

Wrapper cookbook to manage various services that support the Cinc Project.

## Requirements

### Platforms

- AlmaLinux 10

### Cookbooks

- `osl-docker`
- `osl-git`

## Recipes

### default

Empty default recipe.

### rubygems

Deploys [rubygems.cinc.sh](https://rubygems.cinc.sh) via Docker Compose.

- Checks out the source from https://gitlab.com/cinc-project/rubygems.cinc.sh.git to `/opt/rubygems.cinc.sh`
- Creates a data directory at `/data/rubygems.cinc.sh`
- Renders a `.env` file with secrets from the `proj-cinc/rubygems` data bag
- Pulls the `cincproject/rubygems-cinc-sh` Docker image
- Runs two services via `osl_dockercompose`: `geminabox` and `nginx`

#### Data Bag

The `proj-cinc/rubygems` data bag item must contain:

| Key              | Description                          |
| ---------------- | ------------------------------------ |
| `api_key`        | API key for the Geminabox instance   |
| `admin_user`     | Admin username for basic auth        |
| `admin_password` | Admin password for basic auth        |

## Contributing

1. Fork the repository on GitHub
1. Create a named feature branch (like `username/add_component_x`)
1. Write tests for your change
1. Write your change
1. Run the tests, ensuring they all pass
1. Submit a pull request on GitHub

## License and Authors

- Author:: Oregon State University <chef@osuosl.org>

```text
Copyright:: 2025, Oregon State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
