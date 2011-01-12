require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "validates presence of user" do
    p = Post.new
    p.body = "lorem ipsum dolor sit amet..."
    p.topic_id = 1
    assert !p.valid?
    p.user_id = 1
    assert p.valid?
  end

  test "validates presence of body" do
    p = Post.new
    p.topic_id = 1
    p.user_id = 1
    assert !p.valid?
    
    p.body = "lorem ipsum dolor sit amet..."
    assert p.valid?
  end

  test "validates presence of topic" do
    p = Post.new
    p.user_id = 1
    p.body = "lorem ipsum dolor sit amet..."
    assert !p.valid?
    
    p.topic_id = 1
    assert p.valid?
  end
end
