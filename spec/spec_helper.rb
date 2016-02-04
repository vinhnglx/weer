require 'webmock/rspec'
require 'tempo'
require 'byebug'

WebMock.disable_net_connect!(allow_localhost: true)

Dir[__dir__ + '/support/**/*.rb'].each { |f| require f }
