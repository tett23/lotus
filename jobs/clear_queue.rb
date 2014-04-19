class ClearQueueJob < Lotus::Job
  def initialize(env=:development)
    super(env)
    @type = :clear_queue
  end

  def execute!
    Job.all.destroy_all
  end
end
