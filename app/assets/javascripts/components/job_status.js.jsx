/** @jsx React.DOM */

var JobStatus = React.createClass({
  getInitialState: function() {
    return {mutations: []};
  },

  componentDidMount: function() {
    var interval = setInterval(function() {
      d3.json("/stability_job/" + this.props.stability_job_id + "/status", function(err, data) {
        this.setState({mutations: data.mutations});
        console.log(data, data.mutations);
        if (data.all_finished) clearInterval(interval);
      }.bind(this));
    }.bind(this), 1000);
  },

  render: function() {
    console.log(this.state.mutations);
    var mutations = this.state.mutations.map(function(mutation, m_index) {
      return (
        <tr>
          <td>{mutation.mutation}</td>
          {
            mutation.jobs.map(function(job, j_index) {
              return (
                <td>{job.finished ? <Result result={job.result} /> : <Spinner />}</td>
                );
            })
          }
        </tr>
      );
    });
    return (
      <table class="table">
        <thead>
          <tr>
            <th>Mutation name</th>
            <th> </th>
            <th> </th>
            <th> </th>
            <th> </th>
          </tr>
        </thead>
        {mutations}
      </table>
    );
  }
});

var Spinner = React.createClass({
  render: function() {
    return (
      <img src="/assets/spiffygif_28x28.gif" />
    );
  }
});

var Result = React.createClass({
  render: function() {
    return (
      <div>{this.props.result}</div>
    );
  }
});

