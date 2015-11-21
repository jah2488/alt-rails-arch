class PostsController < ApplicationController
  def index
    interactor.index
  end

  def show
    interactor.show
  end

  private
  def interactor
    @interactor ||= PostsInteractor.new(PostsRepository.new, self)
  end
end
