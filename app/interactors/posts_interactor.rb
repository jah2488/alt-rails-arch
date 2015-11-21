class PostsInteractor < ApplicationInteractor

  def index
    posts = repository.all
    controller.render(component: 'PostsIndex', props: { posts: posts }, tag: 'section', class: 'posts')
  end

  def show
    post = repository.find(params[:id]).execute.first
    controller.render(component: 'PostsShow', props: post.attributes, tag: 'section', class: 'post')
  end
end
