require_relative '../test_helper'
require 'minitest'
require 'rack/test'

class LayoutWrapperTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Geminabox::Server
  end

  def setup
    clean_data_dir
    @original_layout_wrapper = Geminabox.layout_wrapper
  end

  def teardown
    Geminabox.layout_wrapper = @original_layout_wrapper
  end

  test 'invokes the configured layout wrapper after rendering html' do
    wrapper = Object.new
    wrapper.define_singleton_method(:call) do |response, _env|
      response['X-Layout-Wrapper'] = 'called'
    end

    Geminabox.layout_wrapper = wrapper

    get '/'

    assert last_response.ok?
    assert_equal 'called', last_response.headers['X-Layout-Wrapper']
  end
end