class ProcessJob < Lotus::Job
  def initialize(env=:development, job_id=nil)
    super(env)
    @type = :process
    @job_id = job_id
  end

  def execute!
    EM.run do
      job = load_job()
      return if job.blank?

      case job.job_type.to_sym
      when :encode
        job.execute!
      when :repair
        job.execute!
      when :destroy_ts
        job.execute!
      when :restructure_queue
        LoadTSJob.new(@env).execute!
        job.destroy
      when :update_schema
        UpdateSchema.new(@env).execute!
        job.destroy
      when :update_output_name
        job.execute!
      when :get_program
        GetProgramJob.new(@env).execute!
        job.destroy
      else
        puts 'undefined job type'
      end

      EM.stop
    end
  end

  private
  def load_job
    if @job_id.blank?
      Job.list.first
    else
      Job.find_by_id(@job_id)
    end
  end
end
