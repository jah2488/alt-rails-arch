class PostsRepository
  include Repository

  #Specify what model this Repository is backing
  for_model Post

  #If attrs in your model differ from your column names, list them here
  map(title: :name)

  def count # This may need to be rolled into the repository module as a one off method, its pretty common and this is ugly
    select('count(*)').raw_execute.flatten.first.to_i
  end

  def find(id)
    where(id: id)
  end

  def published
    where(published: true)
  end

  def by_title(title)
    where(title: title)
  end
end
