class UpdateOutputNameJob < Lotus::Job
  def initialize(env, video_id)
    super(env)
    @type = :update_output_name
    @video_id = video_id
  end

  def execute!
    video = Video.find(@video_id)
    raise "video not found #{@video_id}" if video.nil?

    Lotus::UpdateOutputName.new(video).execute!
  end
end
