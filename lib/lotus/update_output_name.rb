module Lotus
  class UpdateOutputName
    def initialize(video)
      @video = video
      @log = ''
    end
    attr_reader :log

    def execute!
      query = {
        start_at: @video.broadcast_start_at,
        end_at: @video.broadcast_end_at,
        channel_name: @video.channel_name
      }
      program = Program.search(query)
      if program.nil?
        @log += "program not found #{query}"
        return false
      end

      @video.episode_name = program.episode_name
      @video.episode_number = program.count

      @video.update(episode_name: program.episode_name, episode_number: program.count)
      @video.move_output_file(@video.build_output_name)

      true
    end
  end
end
