class UpdateSchema < JobTemplate
  def initialize(env=:development)
    super(env)
    @type = :update_schema
  end

  def execute!
    update_schema!
  end

  private
  def database_schema_path
    base = File.expand_path(__FILE__ + '/../../')
    File.expand_path(File.join(base, 'config/schema.rb'))
  end

  def update_schema!
    load database_schema_path
  end
end
