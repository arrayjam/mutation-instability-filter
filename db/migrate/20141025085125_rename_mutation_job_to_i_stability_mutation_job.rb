class RenameMutationJobToIStabilityMutationJob < ActiveRecord::Migration
  def change
    rename_table :mutation_jobs, :i_stability_mutation_jobs
  end
end
