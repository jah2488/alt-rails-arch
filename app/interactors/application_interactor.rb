class ApplicationInteractor
  attr_reader :repository, :controller
  
  def initialize(repository, controller)
    @repository = repository
    @controller = controller
  end

  def params
    controller.params
  end

  def session
    controller.session
  end
end
