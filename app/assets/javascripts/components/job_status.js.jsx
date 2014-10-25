/** @jsx React.DOM */

var JobStatus = React.createClass({
  componentDidMount: function() {
    var interval = setInterval(function() {
      d3.json("/stability_job/" + this.props.stability_job_id + "/status", function(err, data) {
        console.log(data);
        if (data) clearInterval(interval);
      });
    }.bind(this), 1000);
  },

  render: function() {
    return (
      <div>I are status</div>
    );
  }
});
