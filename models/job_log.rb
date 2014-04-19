class JobLog < ActiveRecord::Base
  enum status: [:failure, :success, :in_progress]
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]

  def self.push(job)
    self.create(
      body: '',
      arguments: job.arguments,
      start_at: DateTime.now,
      status: :in_progress,
      job_id: job.id,
      video_id: (job.video.blank? ? nil : job.video.id),
      job_type: job.job_type
    )
  end

  def finish(status, body)
    self.status = status
    self.body = body
    self.finish_at = DateTime.now

    self.save()
  end

  class << self
    alias_method :<<, :push
  end
end
