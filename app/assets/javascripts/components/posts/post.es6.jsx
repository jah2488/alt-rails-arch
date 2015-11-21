class Post extends React.Component {
  render () {
    return (
      <div>
        <a href={'/posts/' + this.props.id}>Title: {this.props.title}</a>
        <div>Body: {this.props.body}</div>
        <div>Published: {this.props.published}</div>
      </div>
    );
  }
}

Post.propTypes = {
  id: React.PropTypes.number,
  title: React.PropTypes.string,
  body: React.PropTypes.string,
  published: React.PropTypes.bool
};
