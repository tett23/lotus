class ProcessJob < JobTemplate
  def initialize(env=:development)
    super(env)
    @type = :process
  end

  def execute!
    job = Job.new()
    job.type = :encode
    job.arguments = {hoge: :fuga}
    job.save()
    p job
    p job.arguments[:hoge]
  end

  private
  def load_job
    Job.first
  end
end
