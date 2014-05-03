class LoadTSJob < Lotus::Job
  def initialize(env)
    super(env)
    @type = :load_ts
  end

  def execute!
    Dir.entries(Lotus.config[:ts_dir]).reject! do |filename|
      File.extname(filename) != ".ts"
    end.map do |ts_file|
      ts = Lotus::TS.new(ts_file)
      ts.add_program()
      ts.add_error()

      ts
    end.each do |ts|
      v = ts.to_h(:video)
      video = Video.find_by_identification_code(v[:identification_code])
      if video.nil?
        video = Video.create(v)
        unless video.persisted?
          p video.errors.messages
          next
        end
      end

      next unless video.is_encodable
      next if video.is_encoded

      Job.add_repair(video_id: video.id) if !Job.exists_repair?(video.id) && video.has_sd?
      Job.add_encode(video_id: video.id) unless Job.exists_encode?(video.id)
    end
  end
end
