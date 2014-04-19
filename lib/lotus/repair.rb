module Lotus
  class Repair
    def initialize(ts, output_path, width=1280, height=720)
      @ts = ts
      @output_path = output_path
      @width = width
      @height = height
      @input_path = File.join(Lotus.config[:ts_dir], @ts.original_filename)
      @log_path = File.join('log', @ts.identification_code.to_s+'.log')
    end

    def execute!
    command = "sh ts2mp4.sh '#{@input_path}' '#{@output_path}' #{@width} #{@height} 2>#{@log_path}"
    p command

=begin
    unless File.exists?(in_path)
      return {
        result: false,
        command: command,
        message: 'tsが存在しない'
      }
    end

    self.update(:is_encoding => true)

    out = ''
    command_result = systemu(command, :out=>out)
    p command_result

    unless File.exists?(out_path)
      return {
        result: false,
        command: command,
        message: 'ファイルが生成されていない？'
      }
    end

    unless FileUtils.mv(out_path, self.output_path)
      self.update(:is_encoding => false)

      return {
        result: false,
        command: command,
        message: 'ファイルの移動に失敗。NASが起動していない？'
      }
    end

    unless self.video.repaired_ts.blank?
      FileUtils.rm(self.video.repaired_ts)
    end

    {
      result: true,
      command: command,
      message: '正常に終了',
      command_result: command_result,
      log: out,
      filename: self.video.output_path,
      filesize: self.filesize,
      width: self.width,
      height: self.height
    }
=end
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
