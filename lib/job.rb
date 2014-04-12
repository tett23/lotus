class JobTemplate
  def initialize(env=:development)
    @env = env
    establish_db_connection()
  end
  attr_reader :env, :database_config

  def execute!
  end

  private
  def establish_db_connection
    @database_config = YAML.load_file(database_config_path).symbolize_keys[@env].symbolize_keys
    ActiveRecord::Base.establish_connection(@database_config)
  end

  def database_config_path
    base = File.expand_path(__FILE__ + '/../../')
    File.expand_path(File.join(base, 'config/database.yml'))
  end
end
