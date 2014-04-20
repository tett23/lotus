module Lotus
  class DestroyTS
    def initialize(video)
      @video = video
      @log = ''
    end
    attr_reader :log

    def execute!
      if File.exists?(@video.ts_path)
        error_file = @video.ts_path+'.err'
        program_file = @video.ts_path+'.program.txt'

        FileUtils.rm(@video.ts_path)
        FileUtils.rm(error_file) if File.exists?(error_file)
        FileUtils.rm(program_file) if File.exists?(program_file)
      else
        @log = 'file not exists: '+@video.ts_path
        @log += "#{$!.message}\n#{$!.backtrace.join("\n")}"
        return false;
      end

      @log = 'destroy file: '+@video.ts_path
      return true
    end
  end
end
