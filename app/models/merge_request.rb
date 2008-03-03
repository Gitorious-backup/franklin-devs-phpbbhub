class MergeRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :source_repository, :class_name => 'Repository'
  belongs_to :target_repository, :class_name => 'Repository'
  
  attr_protected :user, :status
  
  STATUS_OPEN = 0
  STATUS_MERGED = 1
  STATUS_REJECTED = 2
  
  validates_presence_of :user, :source_repository, :target_repository
  attr_protected :user_id
  
  def self.statuses
    { "Open" => STATUS_OPEN, "Merged" => STATUS_MERGED, "Rejected" => STATUS_REJECTED }
  end
  
  def self.count_open
    count(:all, :conditions => {:status => STATUS_OPEN})
  end
  
  def status_string
    self.class.statuses.invert[status].downcase
  end
  
  def open?
    status == STATUS_OPEN
  end
  
  def merged?
    status == STATUS_MERGED
  end
  
  def rejected?
    status == STATUS_REJECTED
  end
  
  def resolvable_by?(candidate)
    candidate == target_repository.user
  end
end