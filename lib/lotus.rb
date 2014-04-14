module Lotus
  def config
    config_path
    #@config = YAML.load_file()
  end

  private
  def config_path
    root = File.expand_path('../..', __FILE__)
    p root
  end
end
