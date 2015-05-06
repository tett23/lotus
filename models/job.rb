class Job < ActiveRecord::Base
  enum job_type: [:encode, :repair, :restructure_queue, :update_schema, :destroy_ts, :update_output_name, :get_program]

  ENCODE_SIZE = [
    {width: 1440, height: 1080},
    {width: 1280, height: 720},
    {width: 480, height: 360}
  ]

  def self.first
    self.all().order(priority: :desc, id: :desc).first
  end

  def self.list()
    self.all().order(priority: :asc, id: :asc)
  end

  def self.new_priority
    last_item = self.all().order(priority: :desc, id: :desc).first

    if last_item.nil?
      1
    else
      last_item.priority + 1
    end
  end

  def self.repair_jobs
    self.repair
  end

  def self.encode_jobs
    self.encode
  end

  def self.update_output_name_jobs
    self.update_output_name
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

  def self.exists_update_output_name?(video_id)
    not Job.update_output_name_jobs.find do |job|
      job.parsed_arguments[:video_id] === video_id
    end.nil?
  end

  def self.add_repair(arguments)
    arguments = {
      length: '00:00:01.500'
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
      encode_size: ENCODE_SIZE[0]
    }.merge(arguments)
    raise 'video_id is must not be blank' if arguments[:video_id].blank?

    Job.create(
      job_type: :encode,
      arguments: arguments.to_yaml,
      priority: Job.new_priority
    )
  end

  def self.add_update_output_name(arguments)
    raise 'video_id is must not be blank' if arguments[:video_id].blank?

    Job.create(
      job_type: :update_output_name,
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

  def self.running?
    !self.find_by_in_running(true).blank?
  end

  def execute!
    action = self.job_type.to_sym
    return if allow_multi_process?(action) && self.in_running

    log = JobLog << self
    log_body = ''
    status = :failure

    begin
      Job.update(self.id, in_running: true)
      video = self.video
      ts = Lotus::TS.new(video.original_name)
      arguments = self.parsed_arguments

      case action
      when :repair
        runner = Lotus::Repair.new(ts, video, arguments[:length])
        result = runner.execute!
        status = result ? :success : :failure
        log_body = runner.log
      when :encode
        encode_size = arguments[:encode_size].symbolize_keys
        runner = Lotus::Encode.new(ts, video, encode_size[:width], encode_size[:height])
        result = runner.execute!
        status = result ? :success : :failure
        log_body = runner.log
      when :destroy_ts
        runner = Lotus::DestroyTS.new(video)
        result = runner.execute!
        status = result ? :success : :failure
        log_body = runner.log
      when :update_output_name
        runner = Lotus::UpdateOutputName.new(video)
        result = runner.execute!
        status = result ? :success : :failure
        log_body = runner.log
      else
        status = :failure
        log_body = 'invalid job type'
      end
    rescue Interrupt
      status = :failure
      log_body = "Interrupt\n#{$!.to_s}\n#{$!.message}\n#{$!.backtrace.join("\n")}"
    rescue Exception => e
      status = :failure
      log_body = "#{e.message}\n#{e.to_s}\n#{e.backtrace.join("\n")}"
    ensure
      log.finish(status, log_body[0..10000])
      self.destroy
    end
  end

  def allow_multi_process?(action)
    [:repair, :encode].include?(action)
  end
end
