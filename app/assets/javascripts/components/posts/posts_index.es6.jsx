class PostsIndex extends React.Component {
  render () {
    return (
      <Layout>
        Posts:
        {this.props.posts.map((post, id) => {
          return <Post key={id} id={post.id} title={post.title} body={post.body} published={post.published}/>
        })}
      </Layout>
    );
  }
}

PostsIndex.propTypes = {
  posts: React.PropTypes.array
};
