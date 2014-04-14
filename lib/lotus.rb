module Lotus
  def self.config
    @config = YAML.load_file(config_path).symbolize_keys
  end

  private
  def self.config_path
    root = File.expand_path('../..', __FILE__)
    root + '/config/lotus.yml'
  end
end
