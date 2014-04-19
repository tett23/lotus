module Lotus
  class DestroyTS
    def initialize(video)
      @video = video
      @log = ''
    end
    attr_reader :log

    def execute!
      if File.exists?(@video.ts_path)
        FileUtils::DryRun.rm(@video.ts_path)
      else
        @log = 'file not exists: '+@video.ts_path
        return false;
      end

      @log = 'destroy file: '+@video.ts_path
      return true
    end
  end
end
