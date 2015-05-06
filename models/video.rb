class Video < ActiveRecord::Base
  def has_sd?
    `avconv -i "#{ts_path}" 2>#{out_video_info_path}`
    video_info = `cat #{out_video_info_path} | grep Stream | grep 720`

    exists_sd = !!video_info.match(/Video: mpeg2video.+720/)
    FileUtils.rm(out_video_info_path) if File.exists?(out_video_info_path)

    exists_sd
  end

  def ts_path
    "#{Lotus.config[:ts_dir]}/#{self.original_name}"
  end

  def broadcast_start_at
    DateTime.parse("#{self.program.lines.first.gsub(/^(.+)～.+/, '\1').strip} JST")
  end

  def broadcast_end_at
    DateTime.parse("#{self.program.lines.first.gsub(/^(.+) .+～(.+)$/, '\1 \2').strip} JST")
  end

  def channel_name
    self.program.lines[1].strip
  end

  def build_output_name
    "#{self.name}#{self.episode_number ? '#'+self.episode_number.to_s : ''}#{self.episode_name ? "「#{self.episode_name}」" : ''}_#{self.event_id}.mp4"
  end

  def move_output_file(destination)
    if self.is_encoded and not self.saved_directory.blank?
      source_path = File.join(self.saved_directory, self.output_name)
      destination_path = File.join(self.saved_directory, destination)
      unless source_path == destination_path
        FileUtils.mv(source_path, destination_path)
      end
    end

    self.output_name = destination
    self.save()
  end

  private
  def out_video_info_path
    "tmp/video_info_#{self.identification_code}"
  end
end
