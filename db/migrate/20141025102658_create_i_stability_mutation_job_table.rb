class CreateIStabilityMutationJobTable < ActiveRecord::Migration
  def change
    create_table :i_stability_mutation_jobs do |t|
      t.references :stability_job, index: true
      t.string :result
    end
  end
end
