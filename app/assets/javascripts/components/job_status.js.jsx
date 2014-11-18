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
    var mutations = this.state.mutations.map(function(mutation) {
      return (
        <div>
          <h2 className="mutation-name">{mutation.mutation}</h2>
          {
            mutation.jobs.map(function(job) {
              return (
                <div>{job.finished ? (job.type === "DuetStabilityMutationJob" ? <DuetResult stability_job_id={this.props.stability_job_id} job={job} mutation={mutation.mutation} /> : <IStabilityResult result={job.result} />) : <Spinner />}</div>
                );
            }.bind(this))
          }
        </div>
      );
    }.bind(this));
    return (
      <div>{mutations}</div>
      //<th>Mutation</th>
      //<th>iMutant 2.0 PDB</th>
      //<th>AUTO-MUTE RF</th>
      //<th>PoPMuSiC</th>
      //<th>CUPSAT</th>
      //<th>DUET</th>
    );
  }
});

var Spinner = React.createClass({
  render: function() {
    return (
      <div className="spinner"><img src="/assets/spiffygif_28x28.gif" /></div>
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
      <table className="table table-condensed" style={{width: "100%", textAlign: "center", marginTop: "30"}}>
        <thead>
          <tr>
            <th>iMutant 2.0 PDB</th>
            <th>AUTO-MUTE RF</th>
            <th>PoPMuSiC</th>
            <th>CUPSAT</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            {cols}
          </tr>
        </tbody>
      </table>
    );
  }
});

var DuetResult = React.createClass({
  render: function() {
    console.log(this.props);
    var duet = this.props.job,
    results = this.props.job.result.split("\n").map(function(result) {
      return (
        <td>{result}</td>
      );
    });
    return (
      <div>
        <table className="table table-condensed" style={{width: "100%", textAlign: "center", marginTop: "30"}}>
          <thead>
            <tr>
              <th>mCSM Predicted Stability Change</th>
              <th>SDM Predicted Stability Change</th>
              <th>DUET Predicted Stability Change </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              {results}
            </tr>
          </tbody>
        </table>
        <div className="row well">
          <div className="col-xs-6">
            <a className="btn btn-block btn-default" href={duet.pdb_url}>Download PDB File</a>
          </div>
          <div className="col-xs-6">
            <button onClick={selectMol.bind(null, this.props.stability_job_id, duet.id, this.props.mutation)} className="btn btn-block btn-primary pdb_link" value={duet.pdb_url}>View PDB File</button>
          </div>
        </div>
      </div>
      //<td>
      //<a href={duet.pdb_url}>Download PDB File</a>
      //</td>
      //<td>
      //<button onClick={selectMol.bind(null, this.props.stability_job_id, duet.id, this.props.mutation)} className="btn btn-primary pdb_link" value={duet.pdb_url}>View PDB File</button>
      //</td>
    );
  }
});

