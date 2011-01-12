require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PostTest < ActiveSupport::TestCase

  test "validates presence of user" do
    assert false
    p = Post.new
    p.body = "lorem ipsum dolor sit amet..."
    p.topic_id = 1
    assert !p.valid?
    p.user_id = 1
    assert p.valid?
  end

  test "validates presence of body" do
  end

  test "validates presence of topic" do
  end
end
