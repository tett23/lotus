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

  private
  def out_video_info_path
    "tmp/video_info_#{self.identification_code}"
  end
end
