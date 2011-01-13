require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :topics
  fixtures :forums
  fixtures :users

  test "show action redirects to TopicsController#show" do
    get :show, :topic_id => 1, :forum_id => 1, :id => 1

    assert_redirected_to forum_topic_path(1,1)
  end

  test "create action" do
    f = forums(:one)
    t = topics(:one)
    u = users(:one)
    sign_in(u)

    assert_difference "Post.where(:topic_id => #{t.id}).count" do
      post :create, :topic_id => t.id, :forum_id => f.id, :post => {:body => 'test test'}
      assert_redirected_to forum_topic_path(f,t, {:anchor => assigns(:post).dom_id, :page => 1})
    end
  end

  test "update action" do
    f = forums(:one)
    t = topics(:one)
    p = posts(:one)
    u = users(:one)
    sign_in(u)

    put :update, :topic_id => t.id, :forum_id => f.id, :id => p.id, :post => {:body => 'test test'}
    assert_redirected_to forum_topic_path(f,t, {:anchor => p.dom_id, :page => 1})

  end

  test "destroy action" do
    f = forums(:one)
    t = topics(:one)
    u = users(:one)
    p = posts(:one)
    sign_in(u)

    delete :destroy, :topic_id => t.id, :forum_id => f.id, :id => p.id
    assert_redirected_to forum_topic_path(f,t)
  end

  private
  def sign_in(u)
    session[:user_id] = u.id
  end
end
