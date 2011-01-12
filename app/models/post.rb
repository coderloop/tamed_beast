class Post < ActiveRecord::Base
  def self.per_page() 25 end

  belongs_to :forum
  belongs_to :user
  belongs_to :topic

  format_attribute :body
  before_create { |r| r.forum_id = r.topic.forum_id }
  after_create  :update_cached_fields
  after_destroy :update_cached_fields

  validates_presence_of :user_id, :body, :topic_id
  attr_accessible :body	
	
  def editable_by?(user)
    user && (user.id == user_id)
  end
  
  protected
    # using count isn't ideal but it gives us correct caches each time
    def update_cached_fields
      Forum.update_all ['posts_count = ?', Post.count(:id, :conditions => {:forum_id => forum_id})], ['id = ?', forum_id]
      topic.update_cached_post_fields(self)
    end
end
