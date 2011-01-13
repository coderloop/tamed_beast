require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :topics
  fixtures :forums
  fixtures :users

  test "show action redirects to ForumsController#show" do
    f = forums(:one)
    get :show, :id => f.id
    assert_response :success
    assert_equal Topic.where(:forum_id => 1).count, assigns(:forum).topics.size
  end

  test "create action" do
    f = forums(:one)
    u = users(:one)
    sign_in(u)

    assert_difference "Forum.count" do
      post :create, :forum => {:name => 'test forum'}
      f = Forum.last
      assert_redirected_to forum_path(f)
    end
  end

  test "update action" do
    f = forums(:one)
    u = users(:one)
    sign_in(u)

    put :update, :id => f.id, :forum => {:name => 'test test'}
    assert_redirected_to forum_path(f)

  end

  test "destroy action" do
    f = forums(:one)
    u = users(:one)
    sign_in(u)

    delete :destroy, :id => f.id
    assert_redirected_to forums_path
  end

  private
  def sign_in(u)
    session[:user_id] = u.id
  end
end
