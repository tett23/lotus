module Lotus
  class Encode
    def initialize(ts, video, width=1280, height=720)
      @ts = ts
      @video = video
      @output_path = File.join('out', @video.output_name)
      @width = width
      @height = height
      @save_path = File.join(Lotus.config[:save_dir], @video.output_name)
      @input_path = File.join(Lotus.config[:ts_dir], @ts.original_name)
      @log_path = File.join('log', @ts.identification_code.to_s+'.log')
    end

    def execute!
      command = "sh ts2mp4.sh '#{@input_path}' '#{@output_path}' #{@width} #{@height} 2>#{@log_path}"

      unless File.exists?(@input_path)
        return {
          result: false,
          body: "#{command}\ntsが存在しない"
        }
      end

      system(command)

      unless File.exists?(@output_path)
        return {
          result: false,
          body: "#{command}\nファイルが生成されていない？"
        }
      end

      unless FileUtils.mv(@output_path, @save_path)
        return {
          result: false,
          body: "#{command}\nファイルの移動に失敗。NASが起動していない？"
        }
      end

      unless @video.repaired_ts.blank?
        FileUtils.rm(@video.repaired_ts)
      end

      {
        result: true,
        body: log,
      }
    end

    def log
      return '' unless File.exists?(@log_path)

      open(@log_path, 'rb').read.encode!('utf-8', undef: :replace, invalid: :replace, replace: '').gsub(/(\r\n|\r)/, "\n")
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
