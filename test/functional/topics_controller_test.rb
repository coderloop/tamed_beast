require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :topics
  fixtures :forums
  fixtures :users

  test "show action lists posts in a topic" do
    f = forums(:one)
    t = topics(:one)
    get :show, :id => t.id, :forum_id => f.id
    assert_response :success
    assert_equal Post.where(:topic_id => t.id).count, assigns(:posts).size

  end

  test "create action" do
    f = forums(:one)
    u = users(:one)
    sign_in(u)

    assert_difference "Topic.where(:forum_id => #{f.id}).count" do
      post :create, :forum_id => f.id, :topic => {:title => 'test test', :body => 'test test body body'}
      t = Topic.where(:forum_id => f.id).last

      assert_redirected_to forum_topic_path(f,t)
    end
  end

  test "update action" do
    f = forums(:one)
    t = topics(:one)
    u = users(:one)
    sign_in(u)

    put :update, :id => t.id, :forum_id => f.id, :topic => {:title => 'test test'}
    assert_redirected_to forum_topic_path(f,t)
  end

  test "destroy action" do
    f = forums(:one)
    t = topics(:one)
    u = users(:one)
    sign_in(u)

    delete :destroy, :id => t.id, :forum_id => f.id
    assert_redirected_to forum_path(f)
  end

  private
  def sign_in(u)
    session[:user_id] = u.id
  end
end
