class SleepJob
  include Job

  def initialize(time=1)
    @time = time
    @type = :sleep
  end

  def execute!
    sleep @time
  end
end
