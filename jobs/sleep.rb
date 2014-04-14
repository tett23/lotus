class SleepJob < Lotus::Job
  def initialize(env, time=1)
    super(env)
    @time = time
    @type = :sleep
  end

  def execute!
    sleep @time
  end
end
