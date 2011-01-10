class TopicsController < ApplicationController
  before_filter :find_forum_and_topic, :except => :index
  #before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { redirect_to forum_path(params[:forum_id]) }
      format.xml do
        @topics = Topic.paginate_by_forum_id(params[:forum_id], :order => 'sticky desc, replied_at desc', :page => params[:page])
        render :xml => @topics.to_xml
      end
    end
  end

  def new
    @topic = Topic.new
  end

  def show
    respond_to do |format|
      format.html do
        # keep track of when we last viewed this topic for activity indicators
        (session[:topics] ||= {})[@topic.id] = Time.now.utc if !current_user.nil?
        # authors of topics don't get counted towards total hits
        @topic.hit! unless current_user.nil? and @topic.user == current_user
        @posts = @topic.posts.paginate :page => params[:page]
        User.find(:all, :conditions => ['id IN (?)', @posts.collect { |p| p.user_id }.uniq]) unless @posts.nil?
        @post   = Post.new
      end
      format.xml do
        render :xml => @topic.to_xml
      end
    end
  end

  def create
    topic_saved, post_saved = false, false
    Topic.transaction do
      @topic  = @forum.topics.build(params[:topic])
      assign_protected
      @post       = @topic.posts.build(params[:topic])
      @post.topic = @topic
      @post.user  = current_user
      # only save topic if post is valid so in the view topic will be a new record if there was an error
      @topic.body = @post.body # incase save fails and we go back to the form
      topic_saved = @topic.save if @post.valid?
      post_saved = @post.save 
    end

    if topic_saved && post_saved
      respond_to do |format| 
        format.html { redirect_to forum_topic_path(@forum, @topic) }
        format.xml  { head :created, :location => topic_url(:forum_id => @forum, :id => @topic, :format => :xml) }
      end
    else
      render :action => "new"
    end
  end

  def update
    @topic.attributes = params[:topic]
    assign_protected
    @topic.save!
    respond_to do |format|
      format.html { redirect_to forum_topic_path(@forum, @topic) }
      format.xml  { head 200 }
    end
  end

  def destroy
    @topic.destroy
    flash[:notice] = "Topic '{title}' was deleted."[:topic_deleted_message, @topic.title]
    respond_to do |format|
      format.html { redirect_to forum_path(@forum) }
      format.xml  { head 200 }
    end
  end

  protected
  def assign_protected
    @topic.user     = current_user if @topic.new_record?
    return unless admin?
    @topic.sticky, @topic.locked = params[:topic][:sticky], params[:topic][:locked] 
    @topic.forum_id = params[:topic][:forum_id] if params[:topic][:forum_id]
  end

  def find_forum_and_topic
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:id]) if params[:id]
  end

  def authorized?
    %w(new create).include?(action_name) || @topic.editable_by?(current_user)
  end
end
