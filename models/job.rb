class Job < ActiveRecord::Base
  enum type: [:encode, :repair, :restructure_queue, :update_schema]
  belongs_to :video

  def self.first
    self.all().order(priority: :desc, id: :desc).first
  end
end
