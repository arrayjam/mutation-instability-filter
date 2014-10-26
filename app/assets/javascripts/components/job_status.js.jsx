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
          <td>
            {
              mutation.jobs.filter(function(job) { return job.type === "DuetStabilityMutationJob"; }).map(function(duet) {
                return (
                  <div style={{"text-align": "center"}}>
                    <div>{duet.finished ? <a href={duet.pdb_url}>Download PDB File</a> : <span></span>}</div>
                    <div>{duet.finished ? <button onClick={selectMol.bind(null, this.props.stability_job_id, duet.id, mutation.mutation)} className="btn btn-primary pdb_link" value={duet.pdb_url}>View PDB File</button> : <span></span>}</div>
                  </div>
                );
              }.bind(this))
            }
          </td>
        </tr>
      );
    }.bind(this));
    return (
      <table className="table">
        <thead>
          <tr>
            <th>Mutation</th>
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

