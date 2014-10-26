class FixStabilityReference < ActiveRecord::Migration
  def change
    rename_column :mutation_jobs, :StabilityJob_id, :stability_job_id
  end
end
