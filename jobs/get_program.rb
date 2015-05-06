class GetProgramJob < Lotus::Job
  def initialize(env)
    super(env)
    @type = :get_program
  end

  def execute!
    program = Lotus::GetProgram.new()
    program.fetch()
  end
end
