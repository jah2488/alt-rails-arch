class PostsShow extends React.Component {
  render () {
    return (
      <Layout>
        <Post id={this.props.id} title={this.props.title} body={this.props.body} published={this.props.published}/>
      </Layout>
    );
  }
}
