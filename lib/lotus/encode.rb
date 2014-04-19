module Lotus
  class Encode
    def initialize(ts, video, width=1280, height=720)
      @ts = ts
      @video = video
      @output_path = File.join('out', @video.output_name)
      @width = width
      @height = height
      @save_path = File.join(Lotus.config[:save_dir], @video.output_name)
      @input_path = video.repaired_ts.blank? ? File.join(Lotus.config[:ts_dir], @ts.original_name) : video.repaired_ts
      @log_path = File.join('log', @ts.identification_code.to_s+'.log')
      @log = ''
    end
    attr_reader :log

    def execute!
      command = "sh ts2mp4.sh #{Shellwords.shellescape(@input_path)} #{Shellwords.shellescape(@output_path)} #{@width} #{@height} 2>#{@log_path}"

      unless File.exists?(@input_path)
        @log = "#{command}\ntsが存在しない"
        return false
      end

      system(command)

      unless File.exists?(@output_path)
        @log = "#{command}\nファイルが生成されていない？"
        return false
      end

      output_size = filesize()
      unless FileUtils.mv(@output_path, @save_path)
        @log = "#{command}\nファイルの移動に失敗。NASが起動していない？"
        return false
      end

      unless @video.repaired_ts.blank?
        FileUtils.rm(@video.repaired_ts)
      end

      @video.is_encoded = true
      @video.saved_directory = Lotus.config[:save_dir]
      @video.filesize = output_size
      @video.save()

      @log = open(@log_path, 'rb').read.encode!('utf-8', undef: :replace, invalid: :replace, replace: '').gsub(/(\r\n|\r)/, "\n")

      return true
    end

    def filesize
      size = nil
      if File.exists?(@output_path)
        size = File.stat(@output_path).size
      end

      size
    end
  end
end
