class Job
  def initialize(env=:development)
    @env = env
    establish_db_connection()
    update_schema()
  end
  def type
    @type ||= :undefined
  end

  def execute!
  end

  private
  def establish_db_connection
    @database_config = YAML.load_file(database_config_path).symbolize_keys[@env].symbolize_keys
    ActiveRecord::Base.establish_connection(
      adapter: @database_config[:adapter],
      encoding: @database_config[:encoding],
      username: @database_config[:username],
      password: @database_config[:password],
      host: @database_config[:host]
    )
    ActiveRecord::Base.connection.create_database(@database_config[:database]) rescue nil
    ActiveRecord::Base.establish_connection(@database_config)
  end

  def database_config_path
    base = File.expand_path(__FILE__ + '/../../')
    File.expand_path(File.join(base, 'config/database.yml'))
  end

  def database_schema_path
    base = File.expand_path(__FILE__ + '/../../')
    File.expand_path(File.join(base, 'config/schema.rb'))
  end

  def update_schema
    load database_schema_path
  end

  def database_config
  end
end
