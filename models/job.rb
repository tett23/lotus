class Job < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema]

  def self.first
    self.all().order(priority: :desc, id: :desc).first
  end

  def self.list()
    self.all().order(priority: :asc, id: :asc)
  end

  def self.new_priority
    last_item = self.all().order(priority: :desc, id: :desc).first

    if last_item.nil?
      0
    else
      last_item.priority + 1
    end
  end

  def self.repair_jobs
    self.where(job_type: :repair)
  end

  def self.encode_jobs
    self.where(job_type: :repair)
  end

  def self.exists_repair?(video_id)
    not Job.repair_jobs.find do |job|
      job.parsed_arguments[:video_id] === video_id
    end.nil?
  end

  def self.exists_encode?(video_id)
    not Job.encode_jobs.find do |job|
      job.parsed_arguments[:video_id] === video_id
    end.nil?
  end

  ENCODE_SIZE = [
    {width: 1440, height: 1080},
    {width: 1280, height: 720},
    {width: 480, height: 360}
  ]

  def self.add_repair(arguments)
    arguments = {
      length: 1.5
    }.merge(arguments)
    raise 'video_id is must not be blank' if arguments[:video_id].blank?

    Job.create(
      job_type: :repair,
      arguments: arguments.to_yaml,
      priority: Job.new_priority
    )
  end

  def self.add_encode(arguments)
    arguments = {
      encode_size: ENCODE_SIZE[1]
    }.merge(arguments)
    raise 'video_id is must not be blank' if arguments[:video_id].blank?

    Job.create(
      job_type: :encode,
      arguments: arguments.to_yaml,
      priority: Job.new_priority
    )
  end

  def video
    video_id = self.parsed_arguments[:video_id]
    return nil if video_id.blank?

    Video.find_by_id(video_id)
  end

  def parsed_arguments
    return {} unless self.arguments.is_a?(String)
    parsed = YAML.load(self.arguments)
    return {} unless parsed

    parsed.symbolize_keys
  end
end
