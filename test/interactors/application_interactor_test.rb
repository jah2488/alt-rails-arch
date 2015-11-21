require 'test_helper'

class ApplicationInteractionTest < Minitest::Spec
  it 'accepts an instance of a controller, params, and session' do
    assert ApplicationInteractor.new(Struct.new(:repo_goes_here), ApplicationController.new)
  end

  it 'exposes controller instance, params, and session as read only attributes' do
    controller = Struct.new(:params, :session).new

    app_actor = ApplicationInteractor.new(Struct.new(:repo_goes_here), controller)

    assert_equal app_actor.controller, controller
    assert_equal app_actor.params, controller.params
    assert_equal app_actor.session, controller.session
  end
end
