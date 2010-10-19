require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "is public should default to true" do
    @channel = Channel.create(:name => 'test is public flag')
    assert @channel.is_public
  end
end
