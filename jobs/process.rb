class ProcessJob < Lotus::Job
  def initialize(env=:development, job_id=nil)
    super(env)
    @type = :process
    @job_id = job_id
  end

  def execute!
    job = load_job()
    return if job.blank?

    case job.job_type.to_sym
    when :encode
    when :repair
    when :restructure_queue
      LoadTSJob.new(@env).execute!
    when :update_schema
      UpdateSchema.new(@env).execute!
    else
      puts 'undefined job type'
    end
  end

  private
  def load_job
    if @job_id.blank?
      Job.list.first
    else
      Job.find(@job_id)
    end
  end
end
