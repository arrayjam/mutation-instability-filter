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
              var type = job.type;

              return (
                <div>{job.finished ? (type === "DuetStabilityMutationJob" ? <DuetResult job={job} mutation={mutation} /> : <IStabilityResult result={job.result} />) : <Spinner />}</div>
                );
            })
          }
        </tr>
      );
    }.bind(this));
    return (
      <table className="table table-striped table-hover table-condensed" style={{"text-align": "center"}}>
        <thead>
          <tr>
            <th>Mutation</th>
            <th>iMutant 2.0 PDB</th>
            <th>AUTO-MUTE RF</th>
            <th>PoPMuSiC</th>
            <th>CUPSAT</th>
            <th>DUET</th>
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
      <td><img src="/assets/spiffygif_28x28.gif" /></td>
    );
  }
});

var IStabilityResult = React.createClass({
  render: function() {
    var stabilities = JSON.parse(this.props.result).iStability;
    var cols = stabilities.map(function(s) {
      return (
        <td>{s.val}<br />{s.rsa}</td>
      );
    });
    return (
      <div>
        {cols}
      </div>
    );
  }
});

var DuetResult = React.createClass({
  render: function() {
    console.log(this.props.job.result);
    var duet = this.props.job,
    mutation = this.props.mutation,
    results = this.props.job.result.split("\n").map(function(result) {
      return (
        <div>{result}</div>
      );
    });
    return (
      <div>
        <td>{results}</td>
        <td>
          <div>
            <a href={duet.pdb_url}>Download PDB File</a>
          </div>
          <div>
            <button onClick={selectMol.bind(null, this.props.stability_job_id, duet.id, mutation.mutation)} className="btn btn-primary pdb_link" value={duet.pdb_url}>View PDB File</button>
          </div>
        </td>
      </div>
    );
  }
});

