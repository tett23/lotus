class CreateDB < Job
  def initialize(env=:development)
    super
    @type = :create_db
  end

  def execute!
    create_database!
  end

  private
  def create_database!
    ActiveRecord::Base.connection.create_database(@database_config[:database]) rescue nil
  end
end
