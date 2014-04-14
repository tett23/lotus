class LoadTSJob < Lotus::Job
  def initialize(env)
    super(env)
    @type = :load_ts
  end

  def execute!
    Dir.entries(Lotus.config[:ts_dir]).reject! do |filename|
      File.extname(filename) != ".ts"
    end[1..10].map do |ts_file|
      ts = Lotus::TS.new(ts_file)
      ts.add_program()
      ts.add_error()
      p ts.to_hash(:video)
    end
  end
end
