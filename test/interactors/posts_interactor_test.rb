require 'test_helper'

class PostsInteractionTest < Minitest::Spec
  # These tests are *way* to brittle -- Shouldn't couple test failure with specific template name being rendered
  # Not a fan of jumping to mocks so soon, but currently I feel the boundaries of the interactor aren't important.
  it 'renders the posts index' do
    repository = MiniTest::Mock.new
    controller = MiniTest::Mock.new
    interactor = PostsInteractor.new(repository, controller)

    posts = []

    repository.expect :all, posts
    controller.expect :render, true, [{ component: 'PostsIndex', props: { posts: posts }, tag: 'section', class: 'posts' }]

    interactor.index

    assert repository.verify
    assert controller.verify
  end

  it 'renders the posts show' do
    repository = MiniTest::Mock.new
    controller = MiniTest::Mock.new
    interactor = PostsInteractor.new(repository, controller)

    post = Post.new(id: 1, title: 'cool story bro', body: '... broooooo...')

    repository.expect :find, repository, [1]
    repository.expect :execute, [post]

    controller.expect :params, { id: 1 }
    controller.expect :render, true, [{ component: 'PostsShow', props: post.attributes, tag: 'section', class: 'post' }]

    interactor.show

    assert repository.verify
    assert controller.verify
  end
end
