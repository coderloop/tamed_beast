require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :topics
  fixtures :forums

  test "show action redirects to TopicsController#show" do
    get :show, :topic_id => 1, :forum_id => 1, :id => 1

    assert_redirected_to forum_topic_path(1,1)
  end

  test "create action"

  test "update action"

  test "destroy action"
end
