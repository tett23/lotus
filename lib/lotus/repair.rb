module Lotus
  class Repair
    def initialize(ts, video, length)
      @ts = ts
      @video = video
      @length = length
      @output_path = File.join('out', @video.output_name)
      @input_path = File.join(Lotus.config[:ts_dir], @ts.original_name)
      @log_path = File.join('log', @ts.identification_code.to_s+'_repair.log')
    end

    def execute!
      command = "sh ./repair.sh #{Shellwords.shellescape(@input_path)} #{@output_path} #{@length} 2>#{@log_path}"
      system(command)

      @video.repaired_ts = @output_path
      @video.save()

      true
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
