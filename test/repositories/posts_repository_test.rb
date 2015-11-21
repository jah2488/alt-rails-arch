require 'test_helper'

class PostsRepositoryTest < MiniTest::Spec
  let(:subject) { PostsRepository.new }

  after do
    DB.connection.execute("DELETE FROM posts;")
  end

  it 'is the repository for the Post model' do
    assert_equal subject.model, Post
  end

  it 'maps the between the title in the model and name in the database' do
    assert_equal subject.mapping, { title: :name }
  end

  # Since executing the query is separate from constructing the query,
  # your tests can be written against the query or the results of running it.
  describe '#find + #execute' do
    it 'returns empty array for no results' do
      assert_equal subject.find(1).execute, []
    end
    it 'returns records based on their id' do
      subject.insert({ id: 1, title: 'foobar', published: true, body: 'can\'t be blank' })
      assert_equal subject.find(1).execute, [Post.new(id: 1, title: 'foobar', published: true, body: "can't be blank")]
    end
  end

  describe '#count + #execute' do
    it 'gives the total amount of records' do

      subject.insert({title: 'foobar', published: true, body: 'can\'t be blank' })
      subject.insert({title: 'foobar', published: true, body: 'can\'t be blank' })
      subject.insert({title: 'foobar', published: true, body: 'can\'t be blank' })

      assert_equal 3, subject.count
    end
  end

  describe '#published + #execute' do
    it 'returns empty array for no results' do
      assert_equal subject.published.execute, []
    end
    it 'returns only published posts' do
      subject.insert({ id: 1, title: 'foobar', published: true, body: 'can\'t be blank' })
      assert_equal subject.published.execute, [Post.new(id: 1, title: 'foobar', published: true, body: "can't be blank")]
    end
  end

  describe '#by_title + #execute' do
    it 'returns empty array for no results' do
      assert_equal subject.by_title('foobaz').execute, []
    end
    it 'returns records that have title given' do
      subject.insert({ id: 1, title: 'foobar', published: true, body: 'can\'t be blank' })
      assert_equal subject.by_title('foobar').execute, [Post.new(id: 1, title: 'foobar', published: true, body: "can't be blank")]
    end
  end
end
