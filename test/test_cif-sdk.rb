require 'minitest/autorun'
require 'cif-sdk'

# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest.html

@remote = 'https://localhost:8444/api'
@token = '1234444'

class TestCifSdk < Minitest::Test
  def setup
    @cli = CIF::SDK::Client.new(:remote => @remote, :token => @token)
  end
  
  def test_token
    assert_equal @token, @cli.token
  end
  
  def test_remote
    assert_equal @remote, @cli.remote
  end
end
