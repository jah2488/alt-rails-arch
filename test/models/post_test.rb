require 'test_helper'

class PostTest < Minitest::Spec
  it 'can be created with all fields' do
    assert Post.new(id: 1, title: 'my post', published: true, body: 'lorem ipsom...')
  end

  it 'has default for published' do
    p = Post.new(id: 1, title: 'my post', body: 'foobar')
    assert_equal p.published, false
  end

end
