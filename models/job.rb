class Job < ActiveRecord::Base
  enum type: [:encode, :repair]
  belongs_to :video

  def self.first
    self.all().order(priority: :desc, id: :desc).first
  end
end
