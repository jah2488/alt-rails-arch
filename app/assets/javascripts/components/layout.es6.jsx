class Layout extends React.Component {
  render () {
    return (
      <section className="container">
        <nav>
          <ul>
            <li><a href='/'>Home</a></li>
            <li><a href='/posts'>Posts</a></li>
          </ul>
        </nav>
        {this.props.children}
      </section>
    );
  }
}
