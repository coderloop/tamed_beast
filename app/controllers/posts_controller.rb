class PostsController < ApplicationController
  before_filter :find_post,      :except => [:index, :create, :search]
  before_filter :login_required, :except => [:index, :search, :show]
  @@query_options = { :select => "#{Post.table_name}.*, #{Topic.table_name}.title as topic_title, #{Forum.table_name}.name as forum_name", :joins => "inner join #{Topic.table_name} on #{Post.table_name}.topic_id = #{Topic.table_name}.id inner join #{Forum.table_name} on #{Topic.table_name}.forum_id = #{Forum.table_name}.id" }

  def index
    #conditions = []
    #[:user_id, :forum_id, :topic_id].each { |attr| conditions << Post.send(:sanitize_sql, ["#{Post.table_name}.#{attr} = ?", params[attr]]) if params[attr] }
    #conditions = conditions.empty? ? nil : conditions.collect { |c| "(#{c})" }.join(' AND ')
    #@posts = Post.paginate @@query_options.merge(:conditions => conditions, :page => params[:page], :count => {:select => "#{Post.table_name}.id"}, :order => post_order)
    #@users = User.find(:all, :select => 'distinct *', :conditions => ['id in (?)', @posts.collect(&:user_id).uniq]).index_by(&:id)
    #render_posts_or_xml

    @posts = Post.joins(:topics, :forums).order('created_at desc').paginate(:page => params[:page])
  end

  def show
    respond_to do |format|
      format.html { redirect_to forum_topic_path(@post.forum_id, @post.topic_id) }
      format.xml  { render :xml => @post.to_xml }
    end
  end

  def create
    @topic = Topic.find_by_id_and_forum_id(params[:topic_id],params[:forum_id])
    if @topic.locked?
      respond_to do |format|
        format.html do
          flash[:notice] = 'This topic is locked.'[:locked_topic]
          redirect_to(forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id]))
        end
        format.xml do
          render :text => 'This topic is locked.'[:locked_topic], :status => 400
        end
      end
      return
    end
    @forum = @topic.forum
    @post  = @topic.posts.build(params[:post])
    @post.user = current_user
    @post.save!
    email_users_in_topic(@topic)
    respond_to do |format|
      format.html do
        redirect_to forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || '1')
      end
      format.xml { head :created, :location => post_url(:forum_id => params[:forum_id], :topic_id => params[:topic_id], :id => @post, :format => :xml) }
    end
  rescue ActiveRecord::RecordInvalid
    flash[:bad_reply] = 'Please post something at least...'[:post_something_message]
    respond_to do |format|
      format.html do
        redirect_to forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :anchor => 'reply-form', :page => params[:page] || '1')
      end
    end
  end

  def edit
    respond_to do |format| 
      format.html
    end
  end

  def update
    @post.attributes = params[:post]
    @post.save!
  rescue ActiveRecord::RecordInvalid
    flash[:bad_reply] = 'An error occurred'[:error_occured_message]
  ensure
    respond_to do |format|
      format.html do
        redirect_to forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || '1')
      end
      format.xml { head 200 }
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post of '{title}' was deleted."[:post_deleted_message, @post.topic.title]
    respond_to do |format|
      format.html do
        redirect_to(@post.topic.frozen? ? 
                    forum_path(params[:forum_id]) :
                    forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :page => params[:page]))
      end
      format.xml { head 200 }
    end
  end

  protected
  def authorized?
    action_name == 'create' || @post.editable_by?(current_user)
  end

  def post_order
    "#{Post.table_name}.created_at#{params[:forum_id] && params[:topic_id] ? nil : " desc"}"
  end

  def find_post			
    @post = Post.find_by_id_and_topic_id_and_forum_id(params[:id], params[:topic_id], params[:forum_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def email_users_in_topic(topic)
    sent = []
    topic.posts.find(:all, :conditions => ["user_id <> ?", current_user.id]).each do |post|
      unless sent.include?(post.user.id)
        UserMailer.send_later(:deliver_forum_notification, post.user, topic) if post.user.notify_forum?
        sent << post.user_id
      end 
    end
    UserMailer.send_later(:deliver_forum_notification_admin, topic)
  end
end
