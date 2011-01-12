require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  test "validates presence of name" do
    f = Forum.new
    assert !f.valid?
    f.name = "a new forum"
    assert f.valid?
  end
end
