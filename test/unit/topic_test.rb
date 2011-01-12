require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "validates presence of user" do
    t = Topic.new
    t.title = "A new topic"
    t.forum_id = 1
    assert !t.valid?

    t.user_id = 1
    assert t.valid?
  end

  test "validates presence of forum" do
    t = Topic.new
    t.title = "A new topic"
    t.user_id = 1
    assert !t.valid?
    
    t.forum_id = 1
    assert t.valid?
  end

  test "validates presence of title" do
    t = Topic.new
    t.user_id = 1
    t.forum_id = 1
    assert !t.valid?
    
    t.title = "A new topic"
    assert t.valid?
  end
end
