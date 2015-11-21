class Post < Model
  field :id, Fixnum
  field :title, String
  field :published, Boolean, false
  field :body, String
end
