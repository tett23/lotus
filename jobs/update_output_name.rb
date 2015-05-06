class UpdateOutputNameJob < Lotus::Job
  def initialize(env, video_id)
    super(env)
    @type = :update_output_name
    @video_id = video_id
  end

  def execute!
    video = Video.find(@video_id)
    raise "video not found #{@video_id}" if video.nil?

    program = Program.search(start_at: video.broadcast_start_at, end_at: video.broadcast_end_at, channel_name: video.channel_name)
    return if program.nil?

    video.episode_name = program.episode_name
    video.episode_number = program.count

    video.update(episode_name: program.episode_name, episode_number: program.count)
    video.move_output_file(video.build_output_name)
  end
end
