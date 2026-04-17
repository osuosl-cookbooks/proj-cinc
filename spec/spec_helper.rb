require 'chefspec'
require 'chefspec/berkshelf'

ALMA_10 = {
  platform: 'almalinux',
  version: '10',
}.freeze

ALL_PLATFORMS = [
  ALMA_10,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end
